import web, os, hashlib
import requests
import threading
import time
import lxml.objectify

urls = (
    '/', 'index',
    '/reverse', 'reverse',
    '/ioc','ioc',
    '/search', 'search',
    '/search_archive', 'search_archive',
    '/add','add',
    '/process', 'process',
    '/config', 'config',
    '/dash','dashboard',
    '/close','close',
    '/reopen','reopen'
)

db = web.database(dbn='postgres', db='webpy', user='webpy', pw='')

render = web.template.render('/var/www/templates')

web.template.Template.globals.update(dict(
  render = render,
  getsize = os.path.getsize,
))


param_results = db.select('config',what='param_value', where='param_name = \'ELK-IP\'')
for plaso_result in param_results:
    plaso_ip = plaso_result.param_value
param_results = db.select('config',what='param_value', where='param_name = \'Plaso-dash\'')
for plaso_result in param_results:
    plaso_dash = plaso_result.param_value
plaso_url = "http://" + plaso_ip + ":9292/index.html#/dashboard/file/" + plaso_dash
for572_url = "http://" + plaso_ip + ":9292/index.html#/dashboard/file/for572.json"
xplico_url = "http://" + plaso_ip + ":9876/"


class index:
    def GET(self):
        jenkins_url = web.ctx.homedomain + ":8080/"
        return render.tabbed("Forensicator FATE", jenkins_url, plaso_url)


class add:
    def POST(self):
        i = web.input()
        n = db.insert('cases', casename=i.casename,memory_image=i.memory_image,disk_image=i.disk_image,disk_name=i.disk_name,timezone=i.timezone,volatility_profile=i.volatility_profile,notes=i.notes,case_keywords=i.case_keywords,status='open')
        raise web.seeother('/')


class close:
    def POST(self):
        i = web.input()
        n = db.update('cases', where="id = " + i.CASE_ID,status='closed')
        raise web.seeother('/')


class reopen:
    def POST(self):
        i = web.input()
        n = db.update('cases', where="id = " + i.CASE_ID,status='open')
        raise web.seeother('/')


class reverse:
    def GET(self):
        name_hash = []
        for (dirname, dirs, files) in os.walk('/reverse'):
             for filename in files:
                 thefile = os.path.join(dirname,filename)
                 name_hash.append(tuple([thefile, hashlib.md5(open(thefile, 'r').read()).hexdigest()]))

        return render.re_listing(name_hash)


class ioc:
    def GET(self):
        name_hash = []
        for (dirname, dirs, files) in os.walk('/ioc'):
            for filename in files:
                thefile = os.path.join(dirname,filename)
                
                # next 3 lines idea courtesy of Jeff Bryner http://www.jeffbryner.com/blog/itsec/pythoniocdump.html
                ioc_root = lxml.objectify.parse(thefile).getroot()
                short_desc = ioc_root.short_description
                desc = ioc_root.description

                name_hash.append(tuple([thefile, hashlib.md5(open(thefile, 'r').read()).hexdigest(), short_desc, desc]))

        return render.ioc_listing(name_hash)


class search:
    def GET(self):
        return render.listing(db.select('cases',what='*',where="status is null or status<>'closed'",order='id',limit=10000), 'process')


class search_archive:
    def GET(self):
        return render.archive_listing(db.select('cases',what='*',where="status='closed'",order='id',limit=10000))


class config:
    def GET(self):
        return render.cfg_listing(db.select('config',what='*',limit=10000))


class dashboard:
    def GET(self):
        jenkins_url = web.ctx.homedomain + ":8080/"
        return render.dash(plaso_url, jenkins_url, for572_url, xplico_url)


class process:
    def POST(self):
        i = web.input()
        jenkins_url = web.ctx.homedomain + ":8080/"
        jenkins_job_url = jenkins_url + "job/findWindowsEvidence/buildWithParameters"
        jenkins_job_url_with_params = jenkins_job_url + "?CASE_NAME=" + i.CASE_NAME + "&MEMORY_IMAGE_FILE=" + i.MEMORY_IMAGE_FILE + "&DISK_IMAGE_FILE=" + i.DISK_IMAGE_FILE + "&DISK_NAME=" + i.DISK_NAME + "&TIMEZONE=" + i.TIMEZONE + "&VOLATILITY_PROFILE=" + i.VOLATILITY_PROFILE
        threading.Thread(target=requests.get, args=(jenkins_job_url_with_params,)).start()
        raise web.seeother('/')


if __name__ == "__main__":
    app.run()


app = web.application(urls, globals())
application = app.wsgifunc()

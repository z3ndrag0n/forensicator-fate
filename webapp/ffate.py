import web, os, hashlib
import requests
import threading
import time

urls = (
    '/', 'index',
    '/reverse', 'reverse',
    '/search', 'search',
    '/add','add',
    '/process', 'process'
)

db = web.database(dbn='postgres', db='webpy', user='webpy', pw='')

render = web.template.render('/var/www/templates')

web.template.Template.globals.update(dict(
  render = render,
  getsize = os.path.getsize,
))


class index:
    def GET(self):
        jenkins_url = web.ctx.homedomain + ":8080/"
        return render.tabbed("Forensicator FATE", jenkins_url)


class add:
    def POST(self):
        i = web.input()
        n = db.insert('cases', casename=i.casename,memory_image=i.memory_image,disk_image=i.disk_image,disk_name=i.disk_name,timezone=i.timezone,volatility_profile=i.volatility_profile,notes=i.notes,case_keywords=i.case_keywords)
        raise web.seeother('/')


class reverse:
    def GET(self):
        name_hash = []
        for (dirname, dirs, files) in os.walk('/reverse'):
             for filename in files:
                 thefile = os.path.join(dirname,filename)
                 name_hash.append(tuple([thefile, hashlib.md5(open(thefile, 'r').read()).hexdigest()]))

        return render.re_listing(name_hash)


class search:
    # def POST(self):
        # i = web.input()
        # print i
        # return render.listing(db.select('cases',what='*',order='id',limit=10000))
    def GET(self):
        return render.listing(db.select('cases',what='*',order='id',limit=10000), 'process')


class process:
    def POST(self):
        i = web.input()
        jenkins_url = web.ctx.homedomain + ":8080/"
        jenkins_job_url = jenkins_url + "job/findWindowsEvidence/buildWithParameters"
        jenkins_job_url_with_params = jenkins_job_url + "?CASE_NAME=" + i.CASE_NAME + "&MEMORY_IMAGE_FILE=" + i.MEMORY_IMAGE_FILE + "&DISK_IMAGE_FILE=" + i.DISK_IMAGE_FILE + "&DISK_NAME=" + i.DISK_NAME + "&TIMEZONE=" + i.TIMEZONE + "&VOLATILITY_PROFILE=" + i.VOLATILITY_PROFILE
        threading.Thread(target=requests.get, args=(jenkins_job_url_with_params,)).start()
        # print jenkins_job_url_with_params
        # print i
        # time.sleep(1)
        raise web.seeother('/')


if __name__ == "__main__":
    app.run()


app = web.application(urls, globals())
application = app.wsgifunc()

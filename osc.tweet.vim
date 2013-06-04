" vim plugin for oschina's tweet
" author: justin
" contact: gschen.cn@gmail.com
"---------------------------------------
" check the vim supports python

if !has('python')
    echo 'Error: Required vim compile with +python'
    finish
endif

command! -nargs=1 OscTweet exec('py Oschina().tweet(<f-args>)')

python << EOF
import requests 
import hashlib
from BeautifulSoup import BeautifulSoup

username = "YOUR USERNAME"
password = "YOUR PASSWORD"

class Oschina:
    def __init__(self):
        self.login()
       
    def login(self):
        payload = {'email':username,'pwd':hashlib.sha1(password).hexdigest(),'save_login':'1'}
        headers={'User-Agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 '}
        url = 'http://www.oschina.net/action/user/hash_login'
        s = requests.Session()
        r = s.post(url, data=payload, headers=headers)
        #print r.text
        print "login success!"
        self.session = s

    def tweet(self,msg):
        soup = self.getHomePage()
        userId, userCode = self.getUserIdAndCode(soup)

        url = 'http://my.oschina.net/action/tweet/pub'
        payload = {'user':userId, 'user_code':userCode, 'attachment':'0', 'msg':msg}
        headers={'user-agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 ','referer':'https://www.oschina.net/home/login?goto_page=http%3A%2F%2Fwww.oschina.net%2F'}
        r=self.session.post(url,data=payload,headers = headers)
        print r.text
        print "tweet success."

    def getHomePage(self):
        headers={'user-agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 ','referer':'https://www.oschina.net/home/login?goto_page=http%3A%2F%2Fwww.oschina.net%2F'}
        resp = self.session.get("http://my.oschina.net/gschen",headers=headers)
        soup = BeautifulSoup(resp.text)
        return soup

    def getUserIdAndCode(self,soup):
        
        userCode= soup('input', {'name':'user_code'})[0]['value']
        userId= soup('input', {'name':'user'})[0]['value']
        return userId, userCode
EOF

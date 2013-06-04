"   vim plugin for oschina's dongtang
"   author: justin
"   contact: gschen.cn@gmail.com

" check the vim supports python
if !has('python')
    echo 'Error: Required vim compile with +python'
    finish
endif

command! -nargs=1 OscTweet exec('py oscTweet(<f-args>)')

python << EOF
import requests 
import hashlib
from BeautifulSoup import BeautifulSoup

username = "YOUR USERNAME"
password = "YOUR PASSWORD"



userId=""
userCode=""


def login():
    payload = {'email':username,'pwd':hashlib.sha1(password).hexdigest(),'save_login':'1'}
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 '}
    url = 'http://www.oschina.net/action/user/hash_login'
    s = requests.Session()
    r = s.post(url, data=payload, headers=headers)
    print r.text
    print "login success!"
    return s

def tweet(s,msg):
    url = 'http://my.oschina.net/action/tweet/pub'
    payload = {'user':userId, 'user_code':userCode, 'attachment':'0', 'msg':msg}
    headers={'user-agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 ','referer':'https://www.oschina.net/home/login?goto_page=http%3A%2F%2Fwww.oschina.net%2F'}
    r=s.post(url,data=payload,headers = headers)
    print r.text

def getHomePage(s):
    headers={'user-agent':'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 ','referer':'https://www.oschina.net/home/login?goto_page=http%3A%2F%2Fwww.oschina.net%2F'}
    resp = s.get("http://my.oschina.net/gschen",headers=headers)
    soup = BeautifulSoup(resp.text)
    return soup

def getUserId(soup):
    global userId
    userId= soup('input', {'name':'user'})[0]['value']

def getUserCode(soup):
    global userCode
    userCode= soup('input', {'name':'user_code'})[0]['value']

def oscTweet(msg):
    s = login()
    soup = getHomePage(s)
    getUserId(soup)
    getUserCode(soup)
    tweet(s,msg)

EOF

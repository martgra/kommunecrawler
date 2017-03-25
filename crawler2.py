import time
import requests
from bs4 import BeautifulSoup
import re

time = time.strftime("%Y-%m-%d %H:%M:%S")
def postliste_spider(max_pages):
    page=1
    while page <= max_pages:
       url = 'http://innsyn.sande-ve.kommune.no/?commit=S%C3%B8k&enhet=&from_date=&ndoktype=&page=' + str(page) + \
             '&query=&saksaar=&saksnr=&to_date=&utf8=%E2%9C%93'
       source_code = requests.get(url)
       plain_text = source_code.text
       soup = BeautifulSoup(plain_text, 'html.parser')
       for tag in soup.findAll("tr", {'class': 'yang'}):
           tag0 = tag.findAll("td")[0]
           tag1 = tag.findAll("td")[1]
           tag2 = tag.findAll("td")[3]
           tag3 = tag.findAll("td")[4]
           tag4 = tag.findAll("td")[5]
           if tag3.text == "" or "Mottakere" in tag3.text:
               print(tag1.text+"#"+tag0.text+"#"+"ikke oppgitt"+"#"+tag4.text+"#"+tag2.text+"#"+time+"\r")
           else:
               print(tag1.text+"#"+tag0.text+"#"+tag3.text+"#"+tag4.text+"#"+tag2.text+"#"+time+"\r")
                         #i+=1
       for tag in soup.findAll("tr", {'class': 'yin'}):
           tag0 = tag.findAll("td")[0]
           tag1 = tag.findAll("td")[1]
           tag2 = tag.findAll("td")[3]
           tag3 = tag.findAll("td")[4]
           tag4 = tag.findAll("td")[5]
           if tag3.text == "" or "Mottakere" in tag3.text:
               print(tag1.text + "#" + tag0.text + "#" + "ikke oppgitt" + "#" + tag4.text + "#" + tag2.text + "#"+time+ "\r")
           else:
               print(tag1.text + "#" + tag0.text + "#" + tag3.text + "#" + tag4.text + "#" + tag2.text +"#" + time + "\r")
       page +=1
postliste_spider(160)


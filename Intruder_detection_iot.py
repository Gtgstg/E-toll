import RPi.GPIO as GPIO
import time
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from email.mime.base import MIMEBase
from email import encoders
from time import sleep
from picamera import PiCamera

fromaddr = "fazalmahfoozofficial06@gmail.com"# Tinput("Enter your Email ID:")
passwrd="fazal@123"# input("Enter password of your ID:")

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(11, GPIO.IN)         #Read output from PIR motion sensor
GPIO.setup(3, GPIO.OUT)         #LED output pin
while True:
    i=GPIO.input(11)
    if i==1:                 #When output from motion sensor is LOW
        print ("No intruders",i)
        #GPIO.output(3, 0)  #Turn OFF LED
        #time.sleep(0.1)
    elif i==0:               #When output from motion sensor is HIGH
        print ("Intruder detected",i)
        camera = PiCamera()
        camera.resolution = (1024, 768)
        camera.start_preview()
#Camera warm-up time
        sleep(2)
        camera.capture('photo1.jpg', resize=(320, 240))
        toaddr ="fazalmahfooz@gmail.com"# input("Enter Mail ID on which mail has to be send: ")
        msg = MIMEMultipart()
        msg['From'] = fromaddr
        msg['To'] = toaddr
        msg['Subject'] = "ALERT Intruder Detected"# input("Enter Subject :")
 
        body ="Photo of intruder is attached in mail !"# input("Enter Email Body :")
        msg.attach(MIMEText(body, 'plain'))
        filename = "/home/pi/photo1.jpg"
        attachment = open("photo1.jpg", "rb")
    
        p = MIMEBase('application', 'octet-stream')
 
    # To change the payload into encoded form
        p.set_payload((attachment).read())
 
    # encode into base64
        encoders.encode_base64(p)
  
        p.add_header('Content-Disposition', "attachment; filename= %s" % filename)
 
    # attach the instance 'p' to instance 'msg'
        msg.attach(p)
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(fromaddr, passwrd)
        text = msg.as_string()
        server.sendmail(fromaddr, (toaddr,"gaurang888@gmail.com"), text)
        server.quit()
       # GPIO.output(3, 1)  #Turn ON LED
        #time.sleep(0.1)

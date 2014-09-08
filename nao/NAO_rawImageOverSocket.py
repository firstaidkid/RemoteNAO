import threading
import socket
import struct
import time
import zlib
import StringIO
import Image

import gobject
gobject.threads_init()

from naoqi import ALProxy

class SimpleImageServer(threading.Thread):
    '''Creates a new thread for an imageserver. Creates a socket-server to listen for clients and push images from the nao onto the client.'''
    def __init__(self, host, port=8080,fps=15,res=1):
         #cam init
        framerate = fps
        resolution = res
        self.imageWidth, self.imageHeight = (320*resolution), (240*resolution)
        colorSpace = 11   # RGB

        #subscribe to ALVideoDevice to grab images
        self.camProxy = ALProxy('ALVideoDevice')

        # unsubscribe previous instances to avoid collision
        self.camProxy.unsubscribeAllInstances('iPadNao')

        # subscribe and set attributes
        self.gvm = self.camProxy.subscribe('iPadNao', resolution, colorSpace, framerate)     
        
        # server init
        self.ADDR = (host, port)

        # array of currently open sockets (server and clients)
        self.sockets = []
        
        #image
        self.image = StringIO.StringIO()
        
        # status of the RawImageServer - can be accessed with the ping-method
        self.status = "initialised"

        # start thread
        threading.Thread.__init__(self)
        
        
    def send_data(self, client):
        '''Grabs a new image from the NAO-camera and sends it to the client.'''
        # get raw imageData
        data = self.camProxy.getImageRemote(self.gvm)[6]

        # calculate the size of the image-data to determine the number of packages to be sent
        size = struct.pack('!I', len(data))

        # add the size at the beginning of the message
        # this way the client can extract the size and knows how many packages to expect
        message = size + data
        
        # send message
        try:
            # send as many packages as needed to transfer the whole image
            client.sendall(message)
        except Exception as e:
            self.status = "error: "+str(e)
        finally:
            self.close(client)
            pass
    #end send_data
        
    def close(self, s):
        '''Closes an open sockets.'''
        s.close()
        self.sockets.remove(s)
    #end close
        
    def stop(self):
        '''Closes all open sockets and stops the thread.'''
        for s in self.sockets :
            self.close(s)
        
        self.status = "stopped"
        self.stopped = True
    #end stop
    
    def ping(self):
        '''Returns the current status of the ImageServer as well as its current address and open sockets.'''
        return "Server is "+self.status+" with: "+str(len(self.sockets))+ " socket(s), on "+str(self.ADDR)
    #end ping
        
    def run(self):
        '''Main thread.run(). Opens a new socket and waits for clients.'''
        self.status = "trying to run"
        
        try :
            # create socket
            self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

            # set options and start socket
            self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            
            # add to array
            self.sockets.append(self.server)
            
            #self.server.setblocking(True)
            self.server.bind(self.ADDR)
            self.server.listen(5)

            #endless loop
            self.stopped = False
            
            # run loop
            self.status = "running"
            while not self.stopped :
                #accept clients
                client, address = self.server.accept()
                
                #store clients
                self.sockets.append(client)
                
                # send data to clients
                self.send_data(client)   
                            
        except Exception as e:
            self.status = "in error: "+str(e);
            pass
        
        finally :    
            self.stop()
            pass
    #end run
            

class MyClass(GeneratedClass):
    def __init__(self):
        GeneratedClass.__init__(self)

    def onLoad(self):        
        # network init
        host = '' #socket.gethostbyname(socket.gethostname())
        port = self.getParameter("port")
        framerate = self.getParameter("framerate")
        resolution = self.getParameter("resolution")
        self.server = SimpleImageServer(host,port,framerate,resolution)
            
        pass

    def onUnload(self):        
        self.log("Connection closing")
        
        # stop server
        self.server.stop()
        self.server = None

        pass
        
    # pings the server and prints the current status
    def onInput_ping(self):
        self.log("Pinged: "+self.server.ping())
        return self.server

    def onInput_onStart(self):
    
        # start video-server
        try :
            self.log("Start video streamer")
            
            # start thread and call run()
            self.server.start()
            self.log(self.server.ping())
            gobject.MainLoop().run()
        except Exception as e:
            self.log("ERROR starting thread: "+str(e))
        finally :
            self.server.stop()
        pass
        
        
    def onInput_onStop(self):
        self.isServing = False
        self.onUnload()
        pass
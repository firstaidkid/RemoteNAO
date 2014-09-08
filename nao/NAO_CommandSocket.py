from threading import Thread
import socket
import gobject
gobject.threads_init()

class CommandReceiver(Thread):
    '''Creates a new thread for an server. Creates a socket-server to listen for clients and push images from the nao onto the client.'''
    def __init__(self, host, port=12345, funcs=None):
         #cam init
        
        # server init
        self.ADDR = (host, port)

        # array of currently open sockets (server and clients)
        self.sockets = []
        
        # set delegate
        self.funcs = funcs;

        #init done
        self.status = "initialised"
        
        self.command = ["say", "No command called."]

        # start thread
        Thread.__init__(self)
        pass
        
        
    def recv_data(self, client):
        '''Receive a new command from the client.'''

        # receive message
        try:
            # recv. message
            message = client.recv(4096)
            
            # split message into function and parameter
            self.command = message.split(":")
            
            # try to call the function
            if self.funcs is not None:
                if self.command and self.command[1]:                
                    self.funcs[self.command[0]](self.command[1])
                else:
                    self.funcs[self.command[0]]()
                #endif
            else :
                self.funcs['say']("I do not know what you mean.")
            #endif
            
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
        
        #self.status = "stopped"
        self.stopped = True
    #end stop
    
    def ping(self):
        '''Returns the current status of the ImageServer as well as its current address and open sockets.'''
        return "Server is "+self.status + " with: "+str(len(self.sockets))+ " socket(s), on "+str(self.ADDR) + "doing: " + self.command[0] + " with :: " + self.command[1]
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
            
            # bind to an address and start listening
            self.server.bind(self.ADDR)
            self.server.listen(5)

            self.stopped = False
            
            # run loop
            self.status = "running"
            while not self.stopped :
                #accept clients
                self.status = "waiting"
                client, address = self.server.accept()
                
                #store clients
                self.sockets.append(client)

                # send data to clients
                self.recv_data(client)
                self.status = "received"
                            
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
        host = '' #socket.gethostbyname(socket.gethostname())
        port = self.getParameter("port")
    
        # functions with output parameter to call other modules 
        funcs = {
            'relax':self.relax,
            'say':self.say,
            'motion':self.motion,
            'setLED':self.setLED,
            'pingImageSocket':self.pingImageSocket
        }
        
        # init commandReceiver
        self.commandReceiver = CommandReceiver(host,port, funcs)

    def onLoad(self):
        #~ puts code for box initialization here
        pass

    def onUnload(self):
        #~ puts code for box cleanup here
        pass

    def onInput_onStart(self):
        #~ self.onStopped() #~ activate output of the box
        try :
            self.log("Start command receiver.")
            # start thread and call run()
            self.commandReceiver.start()
            self.log(self.commandReceiver.ping())
            gobject.MainLoop().run()
        except Exception as e:
            print "ERROR starting thread: "+str(e)
        finally :
            self.commandReceiver.stop()
        pass

    def onInput_onStop(self):
        self.onUnload() #~ it is recommanded to call onUnload of this box in a onStop method, as the code written in onUnload is used to stop the box as well
        pass
        
    def onInput_onPing(self):
        self.log(self.commandReceiver.ping())
        pass
# LAN-speed-TEST

Web browswer based graphical interface for speed test tool iperf3

NOTE: this is also an example on how to make a graphical interface for a command line tool, using the power of the web technologies.

Setting: a server computer running the command ``iperf3 -s``
a client computer with:
1. iperf3 -speed test client
2. websocketd - command line tool for creating a bridge between command line and websockets
3. speedTest.html - web interface showing grafically the download speed from server
4. speedTest.sh - shell script that runs the whole clinet show
5. Chromium web browser

Install Instructions:
1. install iperf3 and websocketd (ubuntu just use ``sudo apt install iperf3 websocketd`` ) on client computer
2. install iperf3 on server computer
3. download script from Repo
4. edit speedTest.sh and change your server ip address 
5. ``chmod +x ./speedTest.sh``

Usage Instructions:
1. Run ./speedTest.sh
It will start the test, and it will open the html file into the browser.
In the browser you will start see the graph with the test results.
To stop the test press the button on the web-page "close" or press "x" on the browser tab
This will close the browser tab and terminate the client program

NOTEs:
1. The test is set for UDP traffic for max duration of 2000 sec. If you whish to change it, just change the option of the iperf3 tool client side.

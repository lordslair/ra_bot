# RetroAchievements Bot, the project :

This project is mainly a PoC about using the Twitter API, ReroAchievement.org API, and PNG Sprites.  
All of this inside a Docker container for portable purposes.

Actually, as 1.0, it works this way, as soon as you send your RA username to the script via twitter :

 - Fetch Scores, Games recently played, and Achievements RA.org
 - Sort the data and find if you completed a game (100% of achievements)
 - Fetch the Game Icon fom RA.org, and convert it in 64x64
 - Compose the final image by adding PNG layers
 - Reply to your tweet with the PNG as media

### Which script does what ?

I added multiples test scripts as I was coding this to help me, and test almost every function independantly.  
They are located in /test/ folder.

```
├── Dockerfile-perl                   |  To build the docker container
├── docker-compose.yml                |  To start the freshly built container
├── perl                              |
│   ├── data                          |
│   │   └── initDB.pl                 |  DB creation if needed
│   ├── lib                           |
│   │   └── RAB                       |
│   │       ├── SQLite.pm             |  RAB::SQLite     to interact with SQL3 DB
│   │       ├── Twitter.pm            |  RAB::Twitter    to check mentions, and reply
│   │       └── RAAPI.pm              |  RAB::RAAPI      to fetch data from RA.org API
│   ├── twitter-config.yaml           |  Twitter credentials
│   ├── ra-config.yaml                |  RA.org  credentials
│   └── ra_completion                 |  Main script, the Docker endpoint who does all the work
├── src                               |  
│   └── *.png                         |  Contains generated PNG sent to Twitter
└── test                              |  
   └── *.pl                           |  Bunch of test scripts
```

### Tech

I used mainy :

* Perl - as a lazy animal
* [Net::Twitter::Lite::WithAPIv1_1;][CPANTwitt] - Easy Twitter API implementation
* [Image::Magick][CPANIM] - PNG creation from layers
* [DBI] - With SQLite driver for the DB
* [JSON] - Make the output from RA.org usable in the script
* [YAML::Tiny] - THE easy way to deal with YAML files
* [docker/docker-ce][docker] to make it easy to maintain
* [Alpine][alpine] - probably the best/lighter base container to work with
* [Daemon exemple script][daemon] - gobland-it Perl daemon is based on this (Kudos)

And of course GitHub to store all these shenanigans. 

### Installation

The script is aimed to run in a Docker container. Could work without it, but more practical this way.  

```
git clone https://github.com/lordslair/ra_bot
cd ra_bot
docker build --no-cache -t lordslair/ra_bot .
```

```
# docker images
REPOSITORY              TAG                 IMAGE ID            SIZE
lordslair/ra_bot        latest              9e50ff067b1a        225 MB
```

```
docker run --name ra_bot -d lordslair/ra_bot
```

```
docker ps
IMAGE               COMMAND                 CREATED             STATUS              NAMES
lordslair/ra_bot    "/home/ra_bot/ra_bot"   18 hours ago        Up 18 hours         ra_bot
```

```
docker logs ra_bot
2017-08-31 15:22:43 | =====
2017-08-31 15:22:43 | Starting daemon
2017-08-31 15:23:43 | :o) Entering loop 1
2017-08-31 15:24:45 | Got a not yet replied mention from @Lordslair (@ra_completion !Lordslair)
2017-08-31 15:24:45 | [@Lordslair] Got to reply
2017-08-31 15:24:45 | [@Lordslair] Added in DB (440766852,Lordslair)
2017-08-31 15:24:45 | [@Lordslair] Registered on RA (Lordslair), sending ACK Tweet
2017-08-31 15:24:46 | [@Lordslair:Lordslair]   Marked this game (113:Hellfire:normal) as DONE in DB
2017-08-31 15:24:46 | [@Lordslair:Lordslair]     Sending tweet about this
2017-08-31 15:24:47 | [@Lordslair:Lordslair]     /home/ra_bot/img/Lordslair/113.png
2017-08-31 15:24:47 | [@Lordslair:Lordslair]   Marked this game (330:Gynoug:normal) as DONE in DB
2017-08-31 15:24:47 | [@Lordslair:Lordslair]     Sending tweet about this
2017-08-31 15:24:48 | [@Lordslair:Lordslair]     /home/ra_bot/img/Lordslair/330.png
```  

#### Disclaimer/Reminder

>As there's only one script running, it's not wrapped in a start.sh-like script.  
>There's proably **NULL** interest for anyone to clone it and run the script this way, though.  
>(It's currently hardcoded to use @ra_completion Twitter account I registered)  
>I put the code here mostly for reminder, and to help anyone if they find parts of it useful for their own dev.

### Result

These are the PNG generated and sent, respectfully in Normal and Hardcore mode.  
![119][119-Normal]
![6494][6494-Hardcore]  

And here is the result when sent to Twitter.  
![330][330-Twitter]

### Todos

 - Different backgrounds for softcore/HARDCORE
 - lighter container (empty it weights ~225M)
 - ~~logs accessible from outside the container (docker logs stuff)~~
 - /data accessible from outside the container (docker volume stuff)

---
   [CPANTwitt]: <http://search.cpan.org/~mmims/Net-Twitter-Lite-0.12008/lib/Net/Twitter/Lite/WithAPIv1_1.pod>
   [CPANIM]: <http://search.cpan.org/~jcristy/PerlMagick-6.89-1/Magick.pm>
   [daemon]: <http://www.andrewault.net/2010/05/27/creating-a-perl-daemon-in-ubuntu/>
   [docker]: <https://github.com/docker/docker-ce>
   [alpine]: <https://github.com/alpinelinux>

   [119-Normal]: <https://raw.githubusercontent.com/lordslair/ra_bot/master/Screenshot-119-Normal.png>
   [6494-Hardcore]: <https://raw.githubusercontent.com/lordslair/ra_bot/master/Screenshot-6494-Hardcore.png>
   [330-Twitter]: <https://raw.githubusercontent.com/lordslair/ra_bot/master/Screenshot-330-Twitter.png>

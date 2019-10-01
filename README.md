# flutter_geogame

The **flutter_geogame**. is a scavenger hunt like game App, written in Flutter. 
The data is store in Googles Firebase, for the Map it used Mapbox.

I start to develop this App, for a birthday party of a child in my neighborhood. At first, I create this [Web-App](https://github.com/Thro42/vue_geogame) and then I create the Flutter App.

Before you use the App, you must find some places, for hiding small boxes. In case you have two teams, the best strategy is
At the beginning two teams are formed. Let's say Team Red and Team Blue. Both teams start the APP and select their team in the APP. Now the first intermediate station appears on a map for each team. Each team has its own intermediate station and can only see these. If a team finds its waypoint, it will receive a code that it can enter in the APP. This code now makes the next stopover visible. At the same time, the current intermediate station is marked as found. All players, including those of the opposing team now see that a stopover has been found
There are two different waypoints. Code only and Mystery. Code only stations consist of a hidden sign with a code on it. Mystery Stations consist of a small container containing a note with one question and three answers. Here is an example.

<img src="./doc/question.png" height="150">

Behind every answer there is a code and a number with an assigned character or number. The code is used to make the next station visible. The code is needed to find the actual treasure. Here, for the character or the digit must be transferred to a result developed as follows.

<img src="./doc/answer.png" height="60">

If, for example, answer 2 were correct, then a Y would have to be entered in the field. The trick is that each team can only find half of the characters or numbers. In order to find the actual treasure, they also need the digits and signs of the other team.

## Planning the game

In order to be able to plan the game better, we draw on experience from geocaching. In general, you can geocaching and thus our game operate everywhere. Please note, however, land rights and nature conservation. This makes hiding small doses in cities and nature reserves difficult.
In order to plan how many intermediate stations are needed, so the experience that must be scheduled between 5 and 10 minutes for an intermediate station. So, if you want that game to last an hour, you need 11 to 15 hiding places. And you do not need a real hiding place for the real treasure. Here is also a terminus at a hostel, where there are food and drinks. Code only stations usually take less time. The intermediate stations should at the beginning, divide the teams, but bring together again in the end, so that they then find the actual treasure together.

One should pick out the positions and remember the GPS positions. Put together a questionnaire

If you know all stations and their GPS positions, the administration page of the game can be accessed. Here you first set up an event account. This will later also be needed in the APPs and separates the actual games against each other. Subsequently, the individual stations are recorded on the page.

The app should be available for each platform and installed before the game. After installing and starting the app, players log in with the event account. This only has to be done once.

## The Database

To use the app you need to create a projekt on [Firebase](https://console.firebase.google.com/). 

<img src="./doc/firebase1.png" width="200" height="200">

Give the Projekt for example the name geogame.

<img src="./doc/firebase2.png" width="200" height="200">

I testet the Game on android, so her the way to add a [Andriod](https://firebase.google.com/docs/android/setup) app. For IOS follow this Link. **[Add Firebase to your iOS project](https://firebase.google.com/docs/ios/setup)**
Please use **com.geogame.geogame** as your packet name. Otherwise you have to change the build.gardle and the AndroidManifest.xml files.

<img src="./doc/firebase6.png" width="200" height="200">

Download the google-service.json and copy them in the **adroid/app** folder

<img src="./doc/firebase7.png" width="200" height="200">

Now create a database by clicking an **Database** in the menu. 

<img src="./doc/firebase9.png" width="200" height="200">

Set the secure rules to *"Start in test mode"* 

<img src="./doc/firebase10.png" width="200" height="200">

You can hold the rest by default. At next start with a collection by pressing on **"+ Start collection"**. 

<img src="./doc/firebase13.png" width="200" height="200">

Enter the Collection ID **caches**. In the the next dialog you can enter the first cach data. 

<img src="./doc/firebase14.png" width="200" height="200">

but it is posible to change that later. On ["How to upload data to Firebase Firestore Cloud Database"](https://medium.com/@impaachu/how-to-upload-data-to-firebase-firestore-cloud-database-63543d7b34c5), you found a way to fill the caches from a Excel list. A sample list you found hier [CachlisteSample.xlsx](./doc/CachlisteSample.xlsx)
You also can watch my repository [node_geogame](https://github.com/Thro42/node_geogame), wich shows how to load a list in to the database.
The app do not use Accounts so we have to chage the "Sign-in method". To do that select Authentication in the menu.

<img src="./doc/firebase15.png" width="200" height="200">

And on "Sign-in method" enable the method "Anonymous".


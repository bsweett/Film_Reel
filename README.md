#Film_Reel
=========
Final COMP3601 Project

##Problem Addressed
Free alternative to using a photo booth! A simple way for users to be creative in using short video clips cut into five photos to capture a moment. These photos are added to a film reel and sent to a friend. This will help inspire social connections and individual creativity.

##Motivation
Inspired by Snapchat, Vine, and Instagram. Looking to build a fun and exciting application targeted at young adults.
Goals

To build a mobile application called Film Reel that will allow users to add friends. Users will then be able to take a short video in which the application will automatically splice into a five-image film reel. The application acts as a basic image editor to display a ten second period of time in a short photo strip. This photo strip will be displayed similarly to a photo strip from a photo booth. These images can then be sent to specific contacts on your friends list.
A users profile contains a picture, a name, an email address and a short bio. Users also have the option to display their location down to a city. Users will be able to edit their profiles changing any information except their email address. The email address will be used as an identifier for the server.

The applications main page will contain four options. The first option will allow the user to create a film reel, preview this reel, and either retake the video or send to a friend. The second option will allow the user to access a list of their friends, view their profiles and add new friends via email address. The third option will allow the user to view a photo album of their own film reels. The last option will allow the user to check a centralized inbox for friend invites and received reels.

##Objectives
The key library for the project will be AV Foundation (https://developer.apple.com/library/ios/qa/qa1702/_index.html). We will add all of the frames that we gather to an array and we will then divide the total size of the array by six. We will then multiple this value by one, two, three, four and five allowing us to get even frame distribution regardless of the cameras frame rate.

The application will be broken up into three main sections. The first section is the creation and modification of the images from the short video clip. The second section will handle all of the social network aspects such as adding friends and editing your user profile. And finally the final part will be the networking and communication between multiple user devices and the Apache Web Server.
￼￼￼￼￼￼
##Social Aspects
The application will include the following social aspects:
- Profile Pages
- Friend List
- Photo Sharing

##Timeline
Oct 4th: Application communicating with a basic server and database. Users should
be able to create an account and login to the server.
Oct 20th: Users are able to add friends and view their profiles. Users can also edit their own profiles. These changes will be updated to the server accordingly.
Nov 5th: Fully working social network with default image sending.
Nov 20th: Fully working application.
Dec 4th: Presentation and testing complete
*If we are ahead of schedule we will add the users score system first and then built in notifications.

##Optional Features
• A score system, visible on the profile.
• iOS built in notifications. (Service running in background)
• Users can post short text messages to each others profiles
￼￼￼

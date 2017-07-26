+++
title = "Organizations"
weight = 3
+++

In Convox, every Rack and its apps belong to an **organization**. If you're a solo developer, you may have one org with one Rack all to yourself. 

If you work at a company, you might have an org with many users in different roles (admin, operator or developer) that mange apps on many Racks (staging and production).

## Sign Up

Visit the [Convox signup page](https://ui.convox.com/auth/new) to create a free account. Here you can sign up with an email and set a password, or sign up through GitHub or Google.

## Create an Organization

Visit the [new organization page](https://ui.convox.com/org/new) to create a new org. All you need to do is pick a name that is unique.

## Add Users

Visit the [organization page](https://ui.convox.com/org) and click the "Add Another User" button. Enter the email of the user and choose a role.

An **admin** is able to manage everything in Convox, such as:

* Invite additional users
* Change a user role
* Manage integrations
* Install new Racks

A **developer** is not able to do the above. They can only manage apps in Convox, such as:

* Create and delete apps
* Deploy apps
* Set environment variables

## Multiple Organizations

It is common to belong to more than one organization. Perhaps you have one set of Racks you use at work, and another Rack you use for personal projects. Or perhaps you work at large company where the web app team is responsible for one set of apps, and the data science team manages another set of apps, and you'd like to keep these resources separate.

For this, the org dropdown in the navigation is your friend.

In the dropdown you can switch between orgs to change, or click the [New Org](https://ui.convox.com/org/new) to create a new org.

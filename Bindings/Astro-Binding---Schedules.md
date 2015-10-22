# Introduction

Overview of timing an ordering of events supported by the [Astro binding plugin](https://github.com/openhab/openhab/wiki/Astro-binding).

Multiple event types are supported. Each type has two events: start and end.
In general, for all types their start and stop events conincide with a stop or start event of another type.

## Planet: Sun

For the orered list of the following 11 types, the start event is always equal to the end event of the next type. Expect: **morningNight** is always at 0:00 of the current day and **eveningNight** is at 0:00 of the following day.

* morningNight
* astroDawn
* nauticDawn
* civilDawn
* rise
* daylight
* set
* civilDusk
* nauticDusk
* astroDusk
* eveningNight

Type **noon** lasts for only one minute and is during type **daylight**. Type **night** starts together with **eveningNight** and ends together with **morningNight**.

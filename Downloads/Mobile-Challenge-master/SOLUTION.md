# Solution

Please document your solution here



## Questions I would've asked
1. Will we have more than 2 activities to display in current and upcoming ones? What do we want the behavior to be if there are 4 activities to display? Orthogonal scrolling? Vertical scrolling? Fixed?
2. When there are multiple activities in the same order, we currently note this via a "Groups Change In" label above the timer. I'd ask if there is an additional way to inform the user which activity they are currently on out of the "Current Activities." i.e. highlight, different colors, etc.
3. For activities where seconds > 60, do we want to display in minutes, seconds, and milliseconds? Or is it okay that we display the total seconds? i.e. "89:05" vs "1:29:05"
4. What happens after "End Practice"?  I added a "Congrats" alert for closure but here would be a good time to add any notes to tell the team or parent's, etc.
5. What iOS are we supporting? 12?
6. Do we support landscape mode?

## Refactors

1. I tried to keep as much of the logic out of the SportsTimerViewController as possible by managing the data in the ActivitiesManager.swift. There are still some areas where it's not completely modularized, but for the sake of the exercise, I didn't want to create too many unnecessary files with a few lines of code in them.
2. There might be a better way to store the json information than what I've currently got, but I wanted easy ways to access the data without iterating each array of Activities for the same order activities. So I created a few dictionaries to easily search activities, their properties, etc so I could display them on the UI quickly.

## Code Organization

1. SportsTimerViewController.swift - renders data for the main UI
2. Models.swift - stores the structs for the data models (Activity, Material, Instructor), including an ActivityInfo model I created that's contains all the info needed to display on the UI
3. AppColors.swift - set this up in the future if we wanted uniform colors throughout the app

## Enhancements
1. Depending on the user's knowledge of the activities, maybe some video tutorial that shows them what "Tag Me" is.
2. At the end of practice, it would be nice to see an overview of the activities, the time elapsed.
3. It might be helpful to the coach to write some notes during the activity. i.e. "Jill needs to work on her ball handling" or something like that so they can have it all in one place at the end of practice to remind themselves.
4. In future iterations, users could have different activities for different practices. They could create them, mix and match them, and use the app as a practice planning tool. Then when it comes time to run practice, they can press "Start" and use their previously programmed class as a navigation tool.
5. A way for the coach to track metrics - i.e. how many classes run, time spent doing "Kicks" this past season, etc. A way for them to gamify the practice planning and execution process.


## Testing
1. Aside from the sample data, I'd test what happens when there's >2 activities to display. Right now, they would squish together in a stack view, but I would check to see what the desired behavior was.
2. Test scenarios where there aren't matching materialId's from Activity --> Materials. (And same for instructors)
3. I was testing this on an iPhone 11 in the simulator, so I'd check to see what this looks like on other devices. I'm assuming we don't want scroll behavior for smaller screens? i.e. on the iPhone 8, the "MS" label flashes



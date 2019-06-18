# Reception Scheduler

An app to allow staff to view and book shifts at reception with the following contraints...

- Opening hours are 7am until 3am 7 days a week
- Shifts can be 8 hours long
- Only one member of staff per shift
- Employee can work a maximum of 40 hours per week

Oh and build as much as possible in under 4 hours!

## Installation

Clone the project, cd into the directory and run the following...

```
bundle
rails db:create db:migrate db:seed
rails s
```

## Rationale

There are two concepts to be aware of in this implementation:

- `User` - an employee, someone who can view and book a `Shift`
- `Shift` - an booking of time within opening hours to a `User`

### More about `users`

Cool things to do with the user model:

`user.shifts` grab shifts for this user
`user.weekly_hours(date)` returns the total hours booked by that user that week. Date can be any within the week and it will calculate from the beginning of the week to the end.

### More about `shifts`

Shifts require a lot of validations. They can cross days due to overnight opening hours. Furthermore, they are required to be within the confines of the opening hours of the business.

Here are some neat things you can do with shifts:

`shift.duration` returns the duration (in hours) of that shift
`Shift.in_range(past..future)` returns all shifts within the date range regardless of user (useful for knowing if you shift overlaps anyone elses)

## Tests

Tests are built with RSpec and use FactoryBot for test data. Run `rspec` in the console to run the test suite.

## Things I didn't get done in time

- Finishing feature specs for shifts!
- DRYing up the Factories and test data - could be improved by using traits to refactor test data and reduce the amount of setup needed in the tests
- React.js front end form - was intending to have the shift form be able to dynamically query the availability of a shift by calling an endpoint which calls `Shift.availability(date, duration)` and returns a list of available shifts on that day matching the desired duration. This would allow for browsing of available shifts before submitting the form, a much more natural user experience, as well as suggesting upcoming shifts that need filling
- More testing of edge cases. There are a lot of edge cases in this scenario where shifts span multiple days and even cross weekly boundaries yet be within allowable limits. I'm confident my application does a fairly good job of handling these given the time limit but more tests would help me sleep better at night.
- Better front end for finding shifts, be able to toggle between seeing all shifts or just upcoming shifts / past shifts

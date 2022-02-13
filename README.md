# Wandery - HBP 2022
## Inspiration
I love walking all over Boston and trying different coffee shops. The list of places I want to visit someday far outnumbers the number of places I really should visit daily, so I needed a way to track all the different local small businesses I want to patron.

## What it does
Right now, the app shows the places on a map and lets you tag and sort them. In the future, I want to finish setting up the backend in CoreData so that you can add more places and filter them in even more ways.

## How we built it
To challenge myself, I built the app entirely in SwiftUI on my iPad in Swift Playgrounds 4. The drawback of this approach was data persistence is harder to implement. The plus side of the approach is that I could see a preview of my app live as I was coding, something I can't do on my laptop.

## Challenges we ran into
The biggest challenge was squashing bugs as I transferred code from my iPad to my laptop. In the end I decided to save data persistence for another day and to focus on a few more UI adjustments just on the iPad.

## Accomplishments that we're proud of
I'm really proud of the design I managed to implement. I think the app looks at home on iOS through the use of many native design elements. The UX is intuitive and presents the most useful information, where the places are relative to you, in a big map that's easy to understand.

## What we learned
I learned the power of preview data. Right now, the entire UI layer is only using preview data so I wouldn't have an app at all if I hadn't taken the small amount of time it took to build out the preview dataset. Among other learnings was the importance of understanding your backend before building up a complex front-end. I'll be keeping that in mind for my next project.

## What's next for Wandery
Next up I want to finish implementing the data persistence layer. CoreData will give me syncing across devices and the ability to filter efficiently. After that, I want to let users export lists in an easy to share format (similar to how Wordle lets you text your results really easily) so that people can share lists of places to visit with their friends. I'm excited to be able to save and share small businesses and interesting places with friends so that we can explore and see all Boston and other cities have to offer.

# Crypto Practice Docs

Created: May 16, 2023 2:33 PM

# Main Ideas:

1. Display graphs of the day’s data, possibly even with a variable time window
2. Obviously make a JSON decoder
3. Download data periodically to update the app
4. Make some aspects of the UI animated
5. Make the main screen welcome the user, show a few top currencies in value, and then  show a few top currencies sorted by their percentage.
6. Search screen
7. Favorite button that adds the currency to a list. The list of favorites will be shown in a pie chart on a favorites page. Each slice should be evenly divided, since the currency is either favorited or not. This is just to practice using and creating graphs, not to practice the data flow. That part is easy and I can already implement it with no problem.

# How it should be done:

1. I will need a struct for each currency, thinking: id, rank, symbol, name, supply & max supply, price, and 24 hr percent change fields.
2. Separate LinechartView, PieView, and CoinDataView medium-sized. First two are self-explanatory, but the third should be the view that displays all of the data held in the coin struct that isn’t “headline” data (name, price change).
3. List cell view for coins will be needed. It should only have a variable for a coin struct instance that can be passed in as a binding, and should show the coin name and percentage change. This API doesn’t seem to have image logos for each coin, so we will make do without.

# MVVM layout breakdown (Initial)

## Models

Coin

## Views

LineChartView → Line chart view

PieView → Pie chart view

CoinDataView → View holding text displaying coin data such as id, rank, supply & max supply, etc.

CoinCell → List Cell showing coin name & 24 hr price change

TabManagerView → A view that holds a tab controller for the home, search, and favorite views

HomeView → The home screen that shows top coins in a few categories

SearchView → The search screen that allows the user to search for coins by name

FavoriteView → The screen that shows the pie chart breakdown of the user’s favorited coins & the list of them below the chart

CoinView → The detail screen that shows all of the data for the coin

## ViewModels

MainViewModel → Handles getting data from DataFinder and updating the data that is used within each view

Side note: It may be worth using a Set here, since every coin should be different and making each element hashable by name or something may improve search times. I’m not sure if .searchable would take advantage of hashing its input to more quickly find elements within a hashed structure, but it’s worth looking into.

## Miscellaneous

JSONDecoder → JSON decoding and parsing funcs

DataFetcher → Handles data downloading and decoding using JSONDecoder & returning for management in the viewmodel

---

# Day 2 Notes (day 1 was mostly setup and experimenting with JSONDecoder)

1. Learned about the new NavigationStack and the power that value & type based destinations can wield
2. Added .refreshable to all screens displaying lists of data & added onappear() data updates as well
3. Made the data download in DispatchQueue.main.async
4. Connected the viewmodel to the UI and created the main, search, and tabView views
5. Made search animated when removing elements
6. Researched and discovered how to use init() on view structs to set navigation bar appearance attributes for custom title fonts

---

# Day 3 Notes

I spent way too long trying to make the line graph render considering I had the math done in about 20 minutes

---

# Day 4 Notes

1. Added favorite button & spent some time researching bindings and how values update in order to properly integrate favorites. Ran into an interesting problem, that being the fact that since the data is downloaded, I can’t save the favorite status to each coin itself, so I created a set in the main view model that can hold the list of favorited coins
2. Fixed an interesting graph issue. Graphs need to illustrate the relative changes from the initial value, not their value overall. For example if a graph has the max of $500 and a min of $400, my initial approach of showing the values based on a fraction of the maximum won’t illustrate this difference as clearly as making the minimum value effectively 0. For example 400/500 is 4/5, meaning the point would be at a y value 4/5 of the total graph height, but if $400 is the minimum, the graph would ideally only reflect a range of $100 on the y axis and show $400 at the bottom of the graph.
    
    ******************************************************This is the new equation for each y point value: (v is the value, Hs is the screen height)******************************************************
    
    $$
    y=\frac{v-min}{max-min}*H_s
    $$
    
3. I had some trouble making the pie chart appear properly. I realized this was because I forgot to nest my foreach loop creating the pie slices in a zstack, so each slice was its own separate view. The math was easy just like the line chart, and path.closeSubpath() did a lot of the work for me. I created ever-changing colors by multiplying constants by the pie slice number and added a little colored square onto the favorites screen’s coin cells to help show which color is which.
4. The Coin struct needed a == function and a hash function to make sure that equating and hashing was done with only the coin’s id to prevent issues where coin data updating prevented favoriteCoins.contains() from correctly identifying if a coin was stored.

---

# Day 5 Notes

Today I just added in saving functionality with a quick JSON solution. First, I used JSONEncoder to encode an array containing the contents of favoritedCoins (normally stored as an OrderedSet for iterative and efficiency benefits) and then stored the encoded data in UserDefaults. Second, I used JSONDecoder to decode the encoded data stored in UserDefaults and then returned the decoded data in OrderedSet form.

---

# MVVM layout breakdown (Final)

## Models

Coin → A Codable, Identifiable, Hashable, and Comparable class storing coin data

CoinDataResponse → An Codable struct containing an array of coins to be used for decoding the JSON

StampedCoinValue → A Codable, time-stamped coin value

CoinHistoryResponse → A Codable struct containing an array of stamped coin values to be decoded from JSON

historyInterval → Interval codes used to retrieve JSON data including coin values at certain intervals (1 day, 12 hours, 1 hour, etc.) These are used based on the time frame chosen to retrieve a minimum of 12 data points for a given time window.

historyStartTimes → Time offsets used to shrink the data illustrated in the line chart in CoinView to the time window selected

## Views

PieChartView → A basic pie chart used to represent the different favorited coins in FavoriteView

LineChartView → A line chart used to represent the value of a coin over time in CoinView

CoinDataView → A view with text displaying the attributes of a coin

CoinCell → A view used as a list cell containing a coin’s name, symbol, and % change

TabManagerView → The TabView that contains the HomeView, SearchView, and FavoriteView

HomeView → The home view that shows the current top 5 coins in value and the top 5 coins in % daily movement

SearchView → The view that shows a list of all coins and is searchable by name

CoinView → The view that shows a favorite button, graph, data, and button to a website for a coin.

FavoriteView → The view that shows a pie chart representing the coins a user has favorited as well as a color-coordinated list of the coins.

## ViewModels

MainViewModel → The main View Model used for data processing in the Home, Search, and Favorite views

GraphViewModel → The secondary View Model used for data processing for the graph in CoinView

## Misc

JSONDownloader → The functions necessary for downloading the JSON files

CoinDecoder → The functions necessary for downloading JSON files from JSONDownloader and decoding the data

StringExtensions → Extension to the String class including functions that convert strings to doubles and round them

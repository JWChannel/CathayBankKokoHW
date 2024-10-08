
# Swift UIKit MVVM App - Friend List Management

This project implements a friend list management interface using **Swift**, **UIKit**, following the **MVVM** design pattern. 
It supports three different states of the user interface and handles asynchronous API requests to simulate various friend list scenarios.

<p align="center">
    <img src="ReadMeImages/cathay-bank-koko-hw4.gif" alt="cathay" width="540">
</p>

## Features

<p align="center">
    <img src="ReadMeImages/1-0-scenario.png" alt="Scenario" width="200">
</p>

### API Integration and Simulation

Here are the API data sources used in the app:

- **2-(1) User Data**: `https://dimanyen.github.io/man.json`
- **2-(2) Friend List 1**: `https://dimanyen.github.io/friend1.json`
- **2-(3) Friend List 2**: `https://dimanyen.github.io/friend2.json`
- **2-(4) Friend List with Invitations**: `https://dimanyen.github.io/friend3.json`
- **2-(5) No Data (Friends/Invitations)**: `https://dimanyen.github.io/friend4.json`


The app makes asynchronous API requests to simulate the following scenarios:

1. **No Friends**: Displays when there are no friends in the list. Requests data from the API at 2-(5) `https://dimanyen.github.io/friend4.json` (No data returned for friends or invitations).
<p align="center">
    <img src="ReadMeImages/1-1-no-friends.png" alt="No Friends Scenario" width="200">
</p>
   
2. **Friend List Merge**: Shows when there are friends. (**Note: The API still returns one invitation. If you don't want to display the invitationCard, please set inviteLimit to 0 in FriendsVC.**) Makes two API requests to 2-(2) & 2-(3):
    - `https://dimanyen.github.io/friend1.json`
    - `https://dimanyen.github.io/friend2.json`
   

    The results are combined into a list, and if any `fid` data is duplicated between the two, the app uses the record with the most recent `updateDate`.
    
<p align="center">
    <img src="ReadMeImages/1-2-1-friend-list-merge.png" alt="Friends List Scenario" width="200">
</p>

3. **Friend List Only**: Shows when there are friends, without invitations. Requests data from the API at 2-(3):
    - `https://dimanyen.github.io/friend2.json`
   
<p align="center">
    <img src="ReadMeImages/1-2-2-friend-list-only.png" alt="Friends List Scenario" width="200">
</p>


4. **Friend List with Invitations**: Displays when there are friends and the API returns two invitations. Makes a request to 2-(4) `https://dimanyen.github.io/friend3.json` to simulate a scenario where both friends and invitations are present.
<p align="center">
    <img src="ReadMeImages/1-3-1-expanded.png" alt="Friends with Invitations Scenario" width="200">
    <img src="ReadMeImages/1-3-2-stacked.png" alt="Friends with Invitations Scenario" width="200">
</p>

### Search Bar Functionality

- The search bar allows users to search through friends' names.


## Bonus Features

The following additional functionalities are included to enhance the user experience:

1. **Pull-to-Refresh**:
    - The friend list uses **MJRefresh** to support pull-to-refresh functionality. This allows users to refresh the list by pulling it down, which triggers the API to fetch updated data again.
   
2. **Search Bar Push**: When the search bar is tapped, it is pushed to the top under the `UINavigationBar` for better accessibility.
<p align="center">
    <img src="ReadMeImages/1-3-3-search-bar.png" alt="Search bar" width="200">
</p>

3. **Collapsible Invitations**: The invitations section in the friend list supports a collapse and expand action for a cleaner interface.

4. **Unit Testing**: Unit tests are included to verify the behavior of API requests and ensure proper data handling.


---

### Instructions to Run the Project

1. Clone the repository and open the project in Xcode.
2. Build the project using a target device or simulator with iOS 17.2 or later.
3. Test the various UI states by selecting the scenarios on the startup screen.
4. Pull down the list and trigger a refresh of the data.

- Xcode 15.2+
- iOS 17.2+
- Swift 5.9.2+
- **MJRefresh** (Installed via CocoaPods)

### Additional Notes

- Make sure to have an active internet connection while running the app, as it fetches data from remote APIs.

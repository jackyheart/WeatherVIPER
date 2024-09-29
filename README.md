**App Architecture**

![Alt text](documentation/app_architecture.png?raw=true "App Architecture")

1. View interacts with Interactor on view's lifecycle callbacks,<br />
   eg. viewDidLoad(), viewWillAppear(), didSelectRowAt(), searchButtonClicked(), etc.
2. Interactor contains the main business logic, fetching data from Repository.<br /> 
   Interactor is completely agnostic to the data source.
3. Repository abstract out the data layer. It handles fetching data from remote source and local storage.<br />
   With this, one can completely swap one source with another and the app will still work,<br />
   eg. swapping local source UserDefaults with CoreData, Realm, or even in-memory data structure (useful for test purpose),<br />
   or swapping remote source URLSession with networking library, such as Alamofire.
4. Data fetched from Interactor will be passed to Presenter.
5. Presenter formats the data to UI-related view model.
6. Eventually, view will display the UI based on the passed-in view model.


**Additional information**

1. On Use Case 1, it's unclear where data will come from<br />
   For this, I took the liberty of only filtering the stored data,<br />
   as it will not be feasible (not recommended) to keep hittng the api everytime User enters a search string.
   
2. On Use Case 4 & 5<br />
   It doesn't mention how long the cache data should be kept, whether by time elapsed or by number of items.<br />
   In real app, it should be determined on how the local cache should be cleared.<br />
   In this exercise, I've implemented a variable to determine how many items the local cache should store,<br />
   and delete least recently visited items.


**Code Coverage**

![Alt text](documentation/code_coverage.png?raw=true "Code Coverage")

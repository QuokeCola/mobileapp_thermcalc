#  THERMO CALCULATOR
An iOS APP that could calculate certain state of certain substance.
It's based on the text books chart, with a linearly Linear interpolation.

As I wrote this app on macOS High Sierra, it is developed on XCode10.2, iOS 12, and is compable with iOS 11 (As I tested). The code is theorically compable with iOS 13 but I have never upgrade my system and xcode to test it. If someone could help me update it to newest swift or test the code on iOS 13 machine?
# Usage
Just enter e.g."p=1bar, v=0.012m^3/kg" then press enter, you could get the answer.

The keyboard is modified and it is smart.

The Main Menu is simple, like all apple stock apps.

<div div align=center><img src="ThermoCalc/ScreenShots/main_screen.png" width = "30%" height = "30%" /></div>

Using the SearchBar to search. It will provide calculated results as well has search history.

<div div align=center><img src="ThermoCalc/ScreenShots/Search.png" width = "30%" height = "30%" /></div>

Using Substance Picker allows you to change the substance to search.

<div div align=center><img src="ThermoCalc/ScreenShots/Substance_Picker.png" width = "30%" height = "30%" /></div>

And it is compatible with 3D touch Peek&Pop operations.

<div div align=center><img src="ThermoCalc/ScreenShots/3D_touch.png" width = "30%" height = "30%" /></div>

Using swipe to delete search records. Also you could use the delete button to clear all search results.

<div div align=center><img src="ThermoCalc/ScreenShots/DeleteAction.png" width = "30%" height = "30%" /></div>

The App is also compatible to iPad, with providing a large view.

<div div align=center><img src="ThermoCalc/ScreenShots/iPad.png" width = "30%" height = "30%" /></div>

Dynamic keyboard could switch the keyboard type between State input and Decimal Input in portrait mode. 

<div div align=center><img src="ThermoCalc/ScreenShots/Dynamic Keyboard.gif" width = "30%" height = "30%" /></div>

Deleting the Header button always make people forget about input the header. This dynamic button indicator could allows you to touch it and set the header.

<div div align=center><img src="ThermoCalc/ScreenShots/Indicator.gif" width = "30%" height = "30%" /></div>

Horizontal view is designed for landscape orientation of iPhone and all iPads, the keyboard is more straight forward and inproves the efficiency.

<div div align=center><img src="ThermoCalc/ScreenShots/Landscape.gif" width = "100%" height = "100%" /></div>

# Progress
- [x] UI Configuration almost done

- [ ] Datasource setup halfdone.

- [ ] Core aglorithm (In search bar) not started yet.

- [ ] Distribute on App Store

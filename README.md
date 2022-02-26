
# PersonalBank
An app I made to keep track of my spending. Please don't show this to an accountant: I used my own concepts, which probably differ a lot from real accounting

<p align="center">
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/sonibla/PersonalBank" alt="License: MIT"/></a>
    <img src="https://img.shields.io/badge/Open%20Source-%20%E2%99%A5%20-brightgreen" alt="Open Source <3"/>
</p>

## Installation

This app runs on [Pharo](https://pharo.org/) 10.

Once in Pharo, evaluate:
```
Metacello new
    baseline: 'PersonalBank';
    repository: 'github://sonibla/PersonalBank';
    load.
```

## Usage

Evaluate:
```
AccountingNotebookPresenter new openWithSpec
```
Then discover. Maybe my UI should need explanations, maybe not, idk (I did this app for myself so I made it intuitive for me, without following any UI/UX guidelines)

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT) - see the [LICENSE](LICENSE) file for details

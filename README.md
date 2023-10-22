<p align="center">
	<img width="256px" src="https://github.com/GodotParadise/First-Person-Controller/blob/main/icon.jpg" alt="GodotParadiseFirst-Person-Controller logo" />
	<h1 align="center">Godot Paradise First Person Controller</h1>
	
[![LastCommit](https://img.shields.io/github/last-commit/GodotParadise/First-Person-Controller?cacheSeconds=600)](https://github.com/GodotParadise/First-Person-Controller/commits)
[![Stars](https://img.shields.io/github/stars/godotparadise/First-Person-Controller)](https://github.com/GodotParadise/First-Person-Controller/stargazers)
[![Total downloads](https://img.shields.io/github/downloads/GodotParadise/First-Person-Controller/total.svg?label=Downloads&logo=github&cacheSeconds=600)](https://github.com/GodotParadise/First-Person-Controller/releases)
[![License](https://img.shields.io/github/license/GodotParadise/First-Person-Controller?cacheSeconds=2592000)](https://github.com/GodotParadise/First-Person-Controller/blob/main/LICENSE.md)
[![Wiki](https://img.shields.io/badge/Read-wiki-cc5490.svg?logo=github)](https://github.com/GodotParadise/First-Person-Controller/wiki)
</p>

[![es](https://img.shields.io/badge/lang-es-yellow.svg)](https://github.com/GodotParadise/First-Person-Controller/blob/main/locale/README.es-ES.md)

- - -

A ready to go First person controller highly customizable.

- [Requirements](#requirements)
- [✨Installation](#installation)
- [Global Settings](#global-settings)
- [Inputs](#inputs)
  - [Camera](#camera)
  - [Movement](#movement)
  - [Sprint](#sprint)
  - [Crouch](#crouch)
  - [Free look](#free-look)
- [Exported parameters](#exported-parameters)
- [You are welcome to](#you-are-welcome-to)
- [Contribution guidelines](#contribution-guidelines)
- [Contact us](#contact-us)

# Requirements
📢 We don't currently give support to Godot 3+ as we focus on future stable versions from version 4 onwards
* Godot 4+

# ✨Installation
This is a template based repository, to start using you need to use the `Use template` green button on the top right corner of this repository.

This will fork the content from the main branch and initialize a fresh start new project with the first person controller ready to use.

# Global Settings
An autoload class is provided to manage the settings that could be useful to make them available to the player for exchange. Head movement and mouse sensitivity parameter may cause **motion sickness** in some people.

```py
@export_range(1, 10, 1) var MOUSE_SENSITIVITY = 3
@export var HEAD_BOBBING : = true
@export var MOTION_BLUR := true
@export var SWING_HEAD := false
```

# Inputs
This Godot project come with a premade input map, feel free to change it as your needs
## Camera
<kbd>Mouse</kbd> Use the mouse as usual to look around in all directions, the horizontal movement rotates the entire body. To only move the head take a look at [Free look](#free-look)

## Movement 
<kbd>Up</kbd> <kbd>Left</kbd> <kbd>Down</kbd> <kbd>Right</kbd>
<kbd>W</kbd> <kbd>A</kbd> <kbd>S</kbd> <kbd>D</kbd>

## Sprint
<kbd>Shift</kbd> - Run

## Crouch
<kbd>Ctrl</kbd> - Crouch
<kbd>Ctrl</kbd> + <kbd>Shift</kbd> - Crawl

## Free look
<kbd>Alt</kbd> Keep pressed this key to look around with your head using your mouse. Useful when you want to look behind but wanting to keep walking ahead.


# Exported parameters


# You are welcome to
- [Give feedback](https://github.com/GodotParadise/First-Person-Controller/pulls)
- [Suggest improvements](https://github.com/GodotParadise/First-Person-Controller/issues/new?assignees=BananaHolograma&labels=enhancement&template=feature_request.md&title=)
- [Bug report](https://github.com/GodotParadise/First-Person-Controller/issues/new?assignees=BananaHolograma&labels=bug%2C+task&template=bug_report.md&title=)

GodotParadise is available for free.

If you're grateful for what we're doing, please consider a donation. Developing GodotParadise requires massive amount of time and knowledge, especially when it comes to Godot. Even $1 is highly appreciated and shows that you care. Thank you!

- - -
# Contribution guidelines
**Thank you for your interest in Godot Paradise!**

To ensure a smooth and collaborative contribution process, please review our [contribution guidelines](https://github.com/GodotParadise/First-Person-Controller/blob/main/CONTRIBUTING.md) before getting started. These guidelines outline the standards and expectations we uphold in this project.

**Code of Conduct:** We strictly adhere to the [Godot code of conduct](https://godotengine.org/code-of-conduct/) in this project. As a contributor, it is important to respect and follow this code to maintain a positive and inclusive community.

- - -

# Contact us
If you have built a project, demo, script or example with this plugin let us know and we can publish it here in the repository to help us to improve and to know that what we do is useful.
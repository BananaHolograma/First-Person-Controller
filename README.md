<p align="center">
	<img width="256px" src="https://github.com/GodotParadise/First-Person-Controller/blob/main/icon.jpg" alt="GodotParadiseFirst-Person-Controller logo" />
	<h1 align="center">Godot Paradise First Person Controller</h1>
	
[![LastCommit](https://img.shields.io/github/last-commit/GodotParadise/First-Person-Controller?cacheSeconds=600)](https://github.com/GodotParadise/First-Person-Controller/commits)
[![Stars](https://img.shields.io/github/stars/godotparadise/First-Person-Controller)](https://github.com/GodotParadise/First-Person-Controller/stargazers)
[![Total downloads](https://img.shields.io/github/downloads/GodotParadise/First-Person-Controller/total.svg?label=Downloads&logo=github&cacheSeconds=600)](https://github.com/GodotParadise/First-Person-Controller/releases)
[![License](https://img.shields.io/github/license/GodotParadise/First-Person-Controller?cacheSeconds=2592000)](https://github.com/GodotParadise/First-Person-Controller/blob/main/LICENSE.md)
</p>

[![es](https://img.shields.io/badge/lang-es-yellow.svg)](https://github.com/GodotParadise/First-Person-Controller/blob/main/locale/README.es-ES.md)

- - -

A ready to go First person controller highly customizable.

- [Requirements](#requirements)
- [✨Installation](#installation)
- [Global Settings](#global-settings)
- [Exported parameters](#exported-parameters)
- [Accessible normal variables](#accessible-normal-variables)
- [Inputs](#inputs)
  - [Camera](#camera)
  - [Movement](#movement)
  - [Sprint](#sprint)
  - [Crouch](#crouch)
  - [Jump](#jump)
  - [Free look](#free-look)
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
# Exported parameters
```py
## MOUSE AND CAMERA SENSITIVITY
@export_group("Sensitivity")
## The global sensitivity with the mouse that is applied in the entire game camera movement
@export var MOUSE_SENSITIVITY = GlobalSettings.MOUSE_SENSITIVITY
## The camera sensitivity to balance the smoothness of the rotation
@export_range(0, 1, 0.01) var CAMERA_SENSITIVITY := 0.3

## FREE LOOK FEATURE ##
@export_group("Free look")
## Free look feature is active for the controller
@export var FREE_LOOK_ENABLED := true
## The smoothness applied when neck is rotated on free look
@export var FREE_LOOKING_LERP_SPEED := 10.0
## The tilt on degrees for the neck when free look is active
@export var FREE_LOOK_TILT := 5.0
## The initial rotation when free look is active, set to max value to rotate directly the neck to the maximum rotation
@export var FREE_LOOK_INITIAL_ROTATION := 0
## The maximum neck rotation when the character is free looking
@export var FREE_LOOK_MAXIMUM_ROTATION := 120

@export_group("Head bobbing")
## Enable head bobbing for this First person controller
@export var BOB_ENABLED := true
@export var BOB_VECTOR := Vector2.ZERO
@export var BOB_INDEX := 0.0
@export var BOB_LERP_SPEED := 10.0
@export var BOB_SPEED = 7.5
@export var BOB_INTENSITY = 0.1

@export_group("Swing head")
## Enable the swing head when move on horizontal axis (right & left)
@export var SWING_HEAD_ENABLED := false
## The rotation swing to apply in degrees
@export var SWING_HEAD_ROTATION := 5
@export var SWING_HEAD_ROTATION_LERP := 0.05
@export var SWING_HEAD_RECOVERY_LERP := 0.15

@export_group("Camera FOV")
@export var camera_fov_range = [2, 75, 85]


```

# Accessible normal variables
```py
var IS_FREE_LOOKING := false
var LOCKED := false
```


# Inputs
This Godot project come with a premade input map, feel free to change it as your needs
## Camera
<kbd>Mouse</kbd> Use the mouse as usual to look around in all directions, the horizontal movement rotates the entire body. To only move the head take a look at [Free look](#free-look)

## Movement 
<kbd>Up</kbd> <kbd>Left</kbd> <kbd>Down</kbd> <kbd>Right</kbd>
<kbd>W</kbd> <kbd>A</kbd> <kbd>S</kbd> <kbd>D</kbd>

## Sprint
<kbd>Shift</kbd> - Keep pressed this key to run, a sprint runtime can be configured to limit the time the player can run.

## Crouch
<kbd>Ctrl</kbd> - Crouch
<kbd>Shift</kbd> - *(while crouching)* Crawl

if a ceiling collision is detected, it is not necessary to hold down the key to remain in this state.

## Jump
<kbd>Space</kbd>

## Free look
<kbd>Alt</kbd> Keep pressed this key to look around with your head using your mouse. Useful when you want to look behind but wanting to keep walking ahead.




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
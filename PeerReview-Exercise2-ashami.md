# Peer-Review for Programming Exercise 2 #

## Peer-reviewer Information

* *name:* Karim Shami
* *email:* ashami@ucdavis.edu

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The position lock camera's draw_camera_logic wasn't set to true by default as specified. Other than that the camera is locked onto the vessel's position as expected. The cross is correctly drawn as a 5 by 5 unit cross.

___
### Stage 2 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Just like before, the draw_camera_logic isn't true by default. The box is drawn correctly. The vessel is contained inside the box, but not completely (for collision, the vessel's center is checked rather than its sides). The 3 exported fields are there and utilized as expected, where the box moves in the x-z plane with the proper size. On a side note, in terms of game design, it doesn't play well when the vessel has to keep up with the moving frame rather than moving relative with it.

___
### Stage 3 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
draw_camera_logic isn't true by default. The cross is drawn correctly. Besides that, the camera follows and catches up to the vessel as specified. The 3 exported fields are there and utilized as required. The camera also works with hyperspeed, but I noticed that the hyperspeed is hardcoded into the solution. From the gameplay the camera is less than leash distance behind the vessel when its moving with hyperspeed.

___
### Stage 4 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
draw_camera_logic isn't true by default. As expected, the camera moves ahead of the vessel and moves back to it after a specified time. I did notice that the camera moves beyond the leash when using hyperspeed. When I looked at the code I noticed how the camera checks for key inputs rather than taking the vessel's direction vector. The 4 exported fields are there and utilized. The cross is drawn as expected.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
draw_camera_logic isn't true by default. But 1 major flaw is that the camera is moving when the vessel isn't moving. The camera should only move when the vessel moves. When the vessel is between the inner and outer box the camera is moving to keep the vessel inside the inner box, which is wrong in terms of the specifications. A minor flaw is that when the vessel pushes against the outer box it isn't fully touching the border. Besides those flaws, the camera does move in all 4 directions. Both inner and outer boxes are drawn correctly. The 5 exported fields were used, but I noticed 2 extra fields (I discuss this in best practices infractions).
___
# Code Style #

### Code Style Review
The Godot style guide is generally followed but not completely. Proper spacing around fuctions isn't maintained/consistent, private variables aren't prepended with an underscore, and not all variables are typed when declared.
#### Style Guide Infractions ####
- [No type when declaring variables](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/four_way_speedup_push_zone_controller.gd#L26C1-L33C15) - As a part of the Godot style guide, if the type isn't explicitly clear (as in you see the green text for types), it's best to add the type when declaring variables. These lines in the 4-way camera are an example of this.
- [No underscore for private variables](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/framing_horizontal_controller.gd#L23C1-L26C8) - Underscores should be prepended to any private variable names. This link shows an example, but the issue is present in all of the scripts.
#### Style Guide Exemplars ####
- [Typed variables](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/framing_horizontal_controller.gd#L48C2-L51C36) - When drawing the autoscroll camera's box, the left/right/top/bottom variables are properly typed as floats.
- [Proper spacing around _ready()](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/four_way_speedup_push_zone_controller.gd#L12C1-L17C1) - The Godot style guide says to have 1 emptty line before the first function and 2 empty lines between functions. This _ready() function is an example of that.

___
# Best Practices #

### Best Practices Review
The code generally follows best practices but I would prefer if the code is better organized/commented (mainly for the more complex cameras) so that it's written for both understanding and functionality.
#### Best Practices Infractions ####
- [Hardcoded input checks](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/lerp_smoothing_target_lock_controller.gd#L21-L22) - It's not good practice to check for inputs inside any objects that aren't related to the input's intended owner (the vessel). It would be best to check for the vessel's direction through its velocity vector.
- [Unused exported fields](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/four_way_speedup_push_zone_controller.gd#L10-L11) - In the 4-way speedup push zone camera there are 2 extra fields (box_width and box_height). I noticed that they aren't used in the code, so it doesn't make sense to leave them if they serve no purpose.
#### Best Practices Exemplars ####
- [Repurposable camera](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/framing_horizontal_controller.gd#L6) - The horizontal auto scroll camera's auto_scroll field is a Vector3, which would also the camera/code to be generalized to scroll in other directions in the 3D plane.
- [lerp() function](https://github.com/ensemble-ai/exercise-2-camera-control-AnunayAkhaury/blob/f78c978607a53be23210164549940bab5eea6dc6/Obscura/scripts/camera_controllers/lerp_smoothing_target_lock_controller.gd#L50) - Using the lerp() function makes the code more intuitive and allows for curving (by passing a curve function into the weight argument).

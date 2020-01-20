# Broadcast
Broadcast for Godot: Global notification system.

## What is Broadcast for Godot?

Broadcast is a global notification system for the open source Godot Engine. Its goal is to help developers decouple their nodes and scenes to make them independent from one another.
Why did I create Broadcast?

Signals in Godot are awesome, but they generally render nodes too dependent. While signals can be used, in my opinion, to create systems where each nodes live in close proximity to each others (ie a main menu and its different buttons), they are harder to use when creating complex systems with multiple, moveable components.

Consider this scenario:

You have a small scene with 4 components:
 * A player
 * An enemy
 * A label that displays the player's health
 * A button that restores some of the player's health.
 
When the enemy collides with the player, we need to remove some HP and in turn update the health label. When we click the button to restore some health, we need to update both the player's health and the label. Oh and maybe we want to do something with the enemy when the player's health reached 0.

As you can see, each component is dependent on one another if we think with signals. **Broadcast** helps us get rid of this issue. If you want to the this scenario in action, take a look a the supplied example scene called "PlayerHPExample".

## Getting started

To get started [download the latest release](https://github.com/marcgenesis/broadcast/releases/) and save the file `Broadcast.gd` to your Godot project. Add the file to your [autoload](https://docs.godotengine.org/en/3.1/getting_started/step_by_step/singletons_autoload.html) list. You are now ready to use **Broadcast**!

## Documentation

To use **Broadcast**, all you have to do is write Broadcast.function_name() or Broadcast.property since the autoload will make sure it is always available.

### Properties

Type | Name | Description
-----|------|------------
bool|debug|When enabled, all debug messages will appear in Godot's output.
bool|error_handling|When enabled all negative debug messages will appear in Godot's output.
bool|force_registration|When enabled, a message has to be registered before a node can listen to it.

### Methods

In methods, *message* (string) refers to the broadcast message, *listener* (object) refers to the object listening for the message and *action* (string) refers to the method that will be called when the listener hears the message.

#### get_actions(message, listener)

Parameters:
 * message (string)
 * listener (object)

Returns a dictionary containing the list of actions for the listener in the supplied message.

#### get_listeners(message)

Parameters:
 * message (string)
 
Returns a dictionary containing all the listeners for the supplied message. *Key* is the listernet object and *value* is its data.

#### get_messages()

Returns a dictionary containing all the messages. *Key* is the name of the message and *value* is its data.

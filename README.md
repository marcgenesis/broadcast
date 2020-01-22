# Broadcast
Broadcast for Godot: Global notification system.

## What is Broadcast for Godot?

Broadcast is a global notification system for the open source Godot Engine. Its goal is to help developers decouple their nodes and scenes to make them independent from one another.

## Why did I create Broadcast?

Signals in Godot are awesome, but they generally render nodes too dependent. While signals can be used, in my opinion, to create systems where each nodes live in close proximity to each others (ie a main menu and its different buttons), they are harder to use when creating complex systems with multiple, moveable components.

Consider this scenario:

You have a small scene with 4 components:
 * A player
 * An enemy
 * A label that displays the player's health
 * A button that restores some of the player's health.
 
When the enemy collides with the player, we need to remove some HP and in turn update the health label. When we click the button to restore some health, we need to update both the player's health and the label. Oh and maybe we want to do something with the enemy when the player's health reached 0.

As you can see, each component is dependent on one another if we think with signals. **Broadcast** helps us get rid of this issue. If you want to see this scenario in action, take a look a the supplied example scene called "PlayerHPExample". In the scene, you can delete any component you want, and the scene will still run without any errors.

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

Returns a dictionary containing the list of actions for the listener in the supplied message. *Key* is the action object and *value* is a boolean that determines if the action will run once or indefinitely.

#### get_listeners(message)

Parameters:
 * message (string)
 
Returns a dictionary containing all the listeners for the supplied message. *Key* is the listener object and *value* is its data.

#### get_messages()

Returns a dictionary containing all the messages. *Key* is the name of the message and *value* is its data.

#### ignore(message, listener, action)

Parameters:
 * message (string)
 * listener (object)
 * action (string)
 
Returns a boolean (true for success, false for failure). *ignore* is used to remove a specific action from the listener for the supplied message, which means the listener will now *ignore* the broadcast message, but only for the specified action. If the listener is listening to the message with other actions, those will stay.

#### ignore_all(message, listener)

Parameters:
 * message (string)
 * listener (object)
 
Returns a boolean (true for success, false for failure). *ignore_all* stops the listener from listening to the supplied message entirely.

#### is_listening(message, listener, action)

Parameters:
 * message (string)
 * listener (object)
 * action (string - optional)
 
Returns a boolean stating whether or not the listener is listening to the supplied message. If an action is specified, it verifies if the listener is listening with a specific action.

#### is_registered(message)

Parameters:
 * message (string)

Returns a boolean stating whether or not the supplied message is registered.

#### listen(message, listener, action, once)

Parameters:
 * message (string)
 * listener (object)
 * action (string)
 * once (boolean - optional)
 
Returns a boolean (true for success, false for failure). *listen* adds the supplied listener to the supplied message using the specified action. When the message is broadcasted, the action - or method - will be called on the listener. *Once* is optional, and we recommend not to use it directly - see *listen_once* below.

**NOTE**: The method associated with the action requires one parameter that will receive a dictionary containing the parameters. See *send* below.

#### listen_once(message, listener, action)

Parameters:
 * message (string)
 * listener (object)
 * action (string)

Returns a boolean (true for success, false for failure). *listen_once* adds the supplied listener to the supplied message using the specified action. When the message is broadcasted, the action - or method - will be called on the listener and **then the action will be removed**. This means the listener, for this method, will only receive the broadcast once.

**NOTE**: The method associated with the action requires one parameter that will receive a dictionary containing the parameters. See *send* below.

#### register(message)

Parameters:
 * message (string)
 
Returns a boolean (true for success, false for failure). *register* registers the supplied message to the list of registered message. This is mandatory if the property *force_registration* is true.

#### send(message, params)

Parameters:
 * message (string)
 * params (dictionary - optional)
 
Returns a boolean (true for success, false for failure). *send* broadcasts a message to all the actions associated with the listeners that are listening to the supplied message. The *params* are passed to the method called from the action.

#### register(message)

Parameters:
 * message (string)
 
Returns a boolean (true for success, false for failure). *unregister* removes the supplied message from the list of registered message. Only useful when *force_registration* is true.
 

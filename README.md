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

## How it works


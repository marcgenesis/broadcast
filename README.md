# Broadcast
Broadcast for Godot: Global notification system.

## What is Broadcast for Godot?

Broadcast is a global notification system for the open source Godot Engine. Its goal is to help developers decouple their nodes and scenes to make them independent from one another.
Why did I create Broadcast?

Signals in Godot are awesome, but they generally render nodes too dependent. While signals can be used, in my opinion, to create systems where each nodes live in close proximity to each others (ie a main menu and its different buttons), they are harder to use when creating complex systems with multiple, moveable components.

Consider this scenario:

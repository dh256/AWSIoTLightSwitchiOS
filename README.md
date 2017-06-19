# AWSIoTLightSwitch

An iPhone (iOS) app that switches on and off Red, Amber or Green lights connected to a Raspberry Pi.

Connects to AWS IoT hub (using certificate authentication) and publishes a message to a lightCommands topic. A Raspberry Pi app also connects to AWS IoT hub and subscribes to the lightCommands topic. It picks up messages and uses content to switch on/off appropriate light. Message has the format:

```
{
    "name": "<LIGHT_NAME>",
    "state": <0 or 1>
}
``` 

e.g.

```
{
    "name": "RED",
    "state": 1
}
```

switches on RED light.


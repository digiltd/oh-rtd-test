# Controlling openHAB with your voice
This page should give an example how you can control openHAB via natural language without having to write code for every single item you want to control with your voice. 

## Prerequisites

### Voice Recognition systems
You need a working voice recognition system, that sends the recognized text to the VoiceCommand item in openHAB.
The easiest way of doing is by using HABDroid, which works out of the box.

Other possible solutions are Tasker together with AutoVoice of Jasper (on Linux systems).

### Item structure
Your items should follow this naming convention:

    <purpose>_<floorlevel>_<room>_<detail>
    <purpose>    = Shutter, Socket, Light, Temperature,...
    <floorlevel> = GF, FF, SF,...
    <room>       = Bed, Living, Kitchen,...
    <detail>     = Door, Window, ...`

Additionaly there should be one "root"-group which contains all items that should be controllable by voice commands. In the given example this group is named "All"

And you need one String item named VoiceCommand

	String VoiceCommand

## Natural language processing rule (german)

This rule processes German voice commands and should be easily translatable to other languages. 
Basically the rule tries to read the state, the room (and the floorlevel of the room) and the purpose of the item to be changed. Based on this findings the item group "All" is searched for an item named "purpose_floorlevel_room_detail" which accepts the new state.

An additional feature in this rule is the possibility to give responses by TTS (currently only used when the temperature is changed in a room).

	rule "Voice control"
	when
		Item VoiceCommand received command
	then
				var String command = VoiceCommand.state.toString.toLowerCase
		logInfo("Voice.Rec","VoiceCommand received "+command)
		var State newState = null
		// find new state, toggle otherwise (if possible)
		if (command.contains("grad") || command.contains("prozent") || command.contains("dimme")) {
			// extract new state (find the digits in the string)
			var Pattern p = Pattern::compile(".* ([0-9]+) (grad|prozent).*")
			var Matcher m = p.matcher(command)
			if (m.matches()) {
				newState = new StringType(m.group(1).trim())
			}
		}
		else if (command.contains("aus")|| command.contains("ausschalten") || command.contains("beenden")) {
			newState = OFF
		} else if (command.contains("an") || command.contains("ein")|| command.contains("einschalten") || command.contains("starten")) {
			newState = ON
		} else if (command.contains("runterfahren") || command.contains("runter") || command.contains("ab") || command.contains("schließen")) {
			newState = DOWN
		} else if (command.contains("hochfahren") || command.contains("hoch") || command.contains("auf") || command.contains("öffnen")) {
			newState = UP
		} else if (command.contains("rot")) {
			newState = new HSBType(new Color(255, 0, 0));
		} else if (command.contains("blau")) {
			newState = new HSBType(new Color(0, 0, 255));
		} else if (command.contains("weiß")) {
			newState = new HSBType(new Color(255, 255, 255));
		}
		
		// find room
		var String room = null
		var String roomItemPart = null
		var String roomArticle="im"
		if (command.contains("wohnzimmer")) {
			room = "Wohnzimmer"
			roomItemPart = "FF_Living"
		} else if (command.contains("schlafzimmer")) {
			room = "Schlafzimmer"
			roomItemPart = "SF_Bed"
		} else if (command.contains("badezimmer") || command.contains("bad")) {
			room = "Badezimmer"
			roomItemPart = "FF_Toilet"
		} else if (command.contains("arbeitszimmer") || command.contains("büro")) {
			room = "Büro"
			roomItemPart = "FF_Office"
		} else if (command.contains("küche")) {
			room = "Küche"
			roomItemPart = "FF_Kitchen"
			roomArticle = "in der"
		}
		// purpose
		var String itemType=null
		var String itemSubType=""
		var String reply=""
		if (command.contains("licht")) {
			itemType = "Light"
			if (newState instanceof HSBType) {
				if (room=="Schlafzimmer") {
					itemSubType="_Roof"
				} else if (room=="Wohnzimmer") {
					itemSubType="_Closet"
				}
			}
		} else if (command.contains("rolladen") || command.contains("jalousien")) {
			itemType = "Shutter"
			if (newState instanceof StringType) {
				itemType = "Shutter_Pos"
			}
			if (room=="Wohnzimmer") {
				// Unterscheiden zwischen Tür/Fenster
				if (command.contains("tür")) {
					itemSubType = "_Door"
				} else if (command.contains("fenster")) {
					itemSubType = "_Window"
				}
			}
		} else if (command.contains("temperatur")) {
			itemType = "Temperature"
			itemSubType = "_Target"
			reply = "Ok, Temperatur "+roomArticle+" "+room+" auf "+newState+" Grad gesetzt"
		}
		
		if (itemType!=null && (roomItemPart!=null || command.contains("alle")) && newState!=null) {
			logInfo("Voice.Rec", "sending "+newState+" to "+itemType+"_"+roomItemPart+itemSubType)
			if (command.contains("alle")) {
				if (roomItemPart==null)
					roomItemPart=""
				val String itemName = itemType+"_"+roomItemPart+itemSubType
				val State finalState = newState
				logInfo("Voice.Rec","searching for  *"+itemName+"* items")
				All?.allMembers.filter(s | s.name.contains(itemName) && s.acceptedDataTypes.contains(finalState.class)).forEach[item|
					logInfo("Voice.Rec","item  "+item+" found")
					sendCommand(item,finalState.toString)
				]	
			} else {
				sendCommand(itemType+"_"+roomItemPart+itemSubType,newState.toString)
			}
			if (reply!="")
				say(reply)
		}
	end

## TODO
Please feel free to translate this rule into English. If you have a working and well tested solution, please add/replace the rule above.
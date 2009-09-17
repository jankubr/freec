unless defined?(EVENT_WITH_BODY)
EVENT_WITH_BODY=<<STRING
Content-Length: 460
Content-Type: text/event-plain

Event-Name: DETECTED_SPEECH
Core-UUID: b61467b4-6d7c-4a6f-ba87-32ade7b79951
FreeSWITCH-Hostname: air.local
FreeSWITCH-IPv4: 10.0.1.2
FreeSWITCH-IPv6: %3A%3A1
Event-Date-Local: 2009-05-04%2020%3A40%3A48
Event-Date-GMT: Mon,%2004%20May%202009%2018%3A40%3A48%20GMT
Event-Date-Timestamp: 1241462448174337
Event-Calling-File: switch_ivr_async.c
Event-Calling-Function: speech_thread
Event-Calling-Line-Number: 1878
Speech-Type: detected-speech
Content-Length: 132

<interpretation grammar="battle" score="100">
  <result name="match">FREESTYLE</result>
  <input>FREESTYLE</input>
</interpretation>
STRING
end
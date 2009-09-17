unless defined?(EVENT)
EVENT=<<STRING
Content-Length: 1693
Content-Type: text/event-plain

Event-Name: CHANNEL_EXECUTE
Core-UUID: 4a78c88d-38cc-4e35-92af-c155def76f9a
FreeSWITCH-Hostname: air.local
FreeSWITCH-IPv4: 10.0.1.2
FreeSWITCH-IPv6: %3A%3A1
Event-Date-Local: 2009-05-14%2019%3A29%3A09
Event-Date-GMT: Thu,%2014%20May%202009%2017%3A29%3A09%20GMT
Event-Date-Timestamp: 1242322149917313
Event-Calling-File: switch_core_session.c
Event-Calling-Function: switch_core_session_exec
Event-Calling-Line-Number: 1460
Channel-State: CS_EXECUTE
Channel-State-Number: 4
Channel-Name: sofia/internal/jan.kubr.gmail.com%4010.0.1.2
Channel-Destination-Number: 886
Unique-ID: f3c2d5ee-d064-4f55-9280-5be2a65867e8
Call-Direction: inbound
Presence-Call-Direction: inbound
Answer-State: answered
Channel-Read-Codec-Name: GSM
Channel-Read-Codec-Rate: 8000
Channel-Write-Codec-Name: GSM
Channel-Write-Codec-Rate: 8000
Caller-Username: jan.kubr.gmail.com
Caller-Dialplan: XML
Caller-Caller-ID-Name: Jan%20Local
Caller-Caller-ID-Number: jan.kubr.gmail.com
Caller-Network-Addr: 10.0.1.2
Caller-Destination-Number: 0
Caller-Unique-ID: f3c2d5ee-d064-4f55-9280-5be2a65867e8
Caller-Source: mod_sofia
Caller-Context: default
Caller-Channel-Name: sofia/internal/jan.kubr.gmail.com%4010.0.1.2
Caller-Profile-Index: 1
Caller-Profile-Created-Time: 1242322142643329
Caller-Channel-Created-Time: 1242322142643329
Caller-Channel-Answered-Time: 1242322143798188
Caller-Channel-Progress-Time: 0
Caller-Channel-Progress-Media-Time: 1242322142657064
Caller-Channel-Hangup-Time: 0
Caller-Channel-Transfer-Time: 0
Caller-Screen-Bit: true
Caller-Privacy-Hide-Name: false
Caller-Privacy-Hide-Number: false
variable_sip_to_user: 886
variable_sip_from_user: 1001
Application: set
Application-Data: continue_on_fail%3Dtrue

STRING
end
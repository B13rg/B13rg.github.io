---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---
<!-- Image example
![MS-DOS Family Tree](/images/folder/filename.png){:width="700px"}
-->
<!-- Link example -->
[Link to full-size image](public/images/buttons/large/ahmygod.gif)

Footnote[^1]

<!-- Separator -->
---

[^1]: Further information here





netgroup.ua retuns website
Part of the Мережа Netgroup company?

netgroup.ru does not, just some dummy text: `Произвольный текст`

whois marks location as Ivano-Frankovsk, Ukraine.


One was registered in Russia, originally in 2005

Other was registered in ukraine in 2020

At the time it happened, there is no fighting in that area of ukraine, it's all much further east nearer to Kiev and Mykolaiv

Not sure why one is attributed to Russia and the other to Ukraine, seems both are registered in Ukraine.

Gif of event:
![Link to full-size image](/images/bgp/BGP_HJ_212463_2022_3_4.gif)

About page
![](images/bgp/netgroup-ua-about.png)

Looks like they have worked with apartment buildings, to provide internet services potentially.

Some clients:
https://baucomfort.business.site/
https://hydropark.com.ua/
https://mk.if.ua/

Cross-border cooperation projects:

PL-BY-UA 2020
RO-UA 2020
HU-SK-RO-UA 2020
GA-UKR-2016-269919070


Day Before BGP shenanigans:

https://netgroup.ua/24-7/

```
Dear subscribers.

In connection with the imposition of martial law, Netgroup has decided not to suspend the provision of Internet access services to subscribers who have arrears of services.

At the same time, we ask you to pay the subscription fee if possible, because we are actively working 24/7 in the information war against the aggressor.

Glory to Ukraine!!!
```

```
 mmaunder [Tag user]
1 day ago

Prefix 31.148.149.0/24 is normally announced by AS212463 HE shows belongs to https://dataline.ua/en/ which is a Ukrainian company. https://bgp.he.net/AS35297

Is now being announced by AS35004 which HE shows is Ukrainian hosting provider https://netgroup.ua/

But the "Country of origin" of the AS is listed as Russian, which is perhaps where the confusion comes from. https://bgp.he.net/AS35004

About 95% of new AS35004's traffic goes through this peer: (which is Ukrainian) https://bgp.he.net/AS13249

And this peer: (which is Ukrainian) https://bgp.he.net/AS3326

Both of which Peer with Cogent.

What is interesting is that Cogent today decided to cut service to Russia. https://www.reuters.com/technology/us-firm-cogent-cutting-in...

If I was an ISP had networks from UA and RU and my Cogent peering was removed from Russia, I might move some of my traffic through my partner in Ukraine, who does have a peering arrangement with Cogent. I haven't confirmed that is what happened, but you would see this kind of shift I think if they did that.

I'm a security guy and not a CCIE so perhaps a Cisco engineer here can weigh in. 
```

---


https://news.ycombinator.com/item?id=30561518




https://twitter.com/bgpstream/status/1499869790063652868
BGP,HJ,hijacked prefix AS212463 31.148.149.0/24, NGROUP, UA,-,By AS35004 NETGRUP, RU, http://bgpstream.com/event/287556


https://bgp.he.net/AS212463
https://bgp.he.net/AS35004

https://whois.ipip.net/AS212463
https://whois.ipip.net/AS35004

---

## Summary Table

|Org Name | FOP Polischyk O.V | Branch Enterprise "Netgroup-Service" |
|AS Name | NGroup | NETGRUP |
|ASN | AS212463 | AS35004 |
|Country | Ukraine (UA) | Russia (RU) |
|AS Create Date | Oct. 22 2020 | May 17 2005 |
|Website |  | http://netgroup.ua  |
|Whois Person | - |Andrew Belocur
|Whois Address | 23 Sakharov st., Ivano-Frankivsk, Ukraine |13, Gryhevsky Str. <br> Ivan-Frankivsk, Ukraine|
|Whois Email | office@netgroup.ua <br>(Whois of this points to com.if.ua) | office@com.if.ua |
|Prefixes | 31.148.149.0/24 | 45.131.164.0/24 |
| | 95.47.59.0/24 | 45.131.166.0/24 |
| |  | 93.170.116.0/22 |
| |  | 93.170.118.0/24 |
| |  | 185.183.110.0/23 |
| |  | 194.126.180.0/22 |
| |  | 195.74.72.0/24 |
| |  | 195.162.80.0/22 |
|Links | https://bgp.he.net/AS212463 | https://bgp.he.net/AS35004 |
| | https://whois.ipip.net/AS212463 | https://whois.ipip.net/AS35004 |
| | https://bgpview.io/asn/212463 | https://bgpview.io/asn/35004 |


## AS212463: FOP Polischyk O.V

ASN Name: NGroup

* IPv4 Addresses: 512
* Number of Peers: 1
* Number of Prefixes: 2
* ASN Allocated: 22nd October 2020

### Links

* https://bgp.he.net/AS212463
* https://whois.ipip.net/AS212463
* https://bgpview.io/asn/212463



### Prefixes
```
Country 	Announced Prefix 	Description 	Valid ROA 	Parent Prefix
Ukraine (UA) Flag 	31.148.149.0/24 	SF NetGroup-Service 		31.148.0.0/16
Ukraine (UA) Flag 	95.47.59.0/24 	SF NetGroup-Service 		95.46.0.0/15
```

### Summary
```
AS212463 Summary
Regional Registry: RIPE
Allocation Status: Allocated
Allocation Date: 22nd October 2020
Allocated Country: Ukraine (UA) Flag
Traffic Ratio: Not Disclosed
AS212463 Network
IPv4 Prefixes: 2
IPv4 Peers: 1
IPv4 Upstreams: 1
IPv6 Prefixes: 0
IPv6 Peers: 0
IPv6 Upstreams: 0
Contacts
Email Contacts:
admin@com.if.ua
office@netgroup.ua
support@netgroup.ua
Abuse Contacts:
support@netgroup.ua
Address:
Ukraine,
Ivan-Frankivsk,
Saharova,
23-z
```

### Whois

```
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Information related to 'AS212463'

% Abuse contact for 'AS212463' is 'admin@com.if.ua'

aut-num:        AS212463
as-name:        NGroup
org:            ORG-FPO1-RIPE
import:         from AS35297 accept ANY
import:         from AS35004 accept ANY
export:         to AS35297 announce AS212463
export:         to AS35004 announce AS212463
admin-c:        SNN49-RIPE
tech-c:         SNN49-RIPE
status:         ASSIGNED
mnt-by:         RIPE-NCC-END-MNT
mnt-by:         NGroup-MNT
mnt-by:         DL-MNT
created:        2020-10-22T14:52:37Z
last-modified:  2021-03-13T14:58:31Z
source:         RIPE
sponsoring-org: ORG-DL91-RIPE

organisation:   ORG-FPO1-RIPE
org-name:       FOP Polischyk O.V
org-type:       OTHER
address:        Ukraine, Ivan-Frankivsk, Saharova, 23-z
e-mail:         office@netgroup.ua
abuse-c:        AR30032-RIPE
mnt-ref:        NGroup-MNT
mnt-by:         DL-MNT
created:        2020-10-20T11:29:33Z
last-modified:  2020-11-17T11:01:39Z
source:         RIPE

role:           SF NetGroup-Service NOC
address:        23 Sakharov st., Ivano-Frankivsk, Ukraine
e-mail:         office@netgroup.ua
admin-c:        OB4268-RIPE
tech-c:         OB4268-RIPE
nic-hdl:        SNN49-RIPE
abuse-mailbox:  support@netgroup.ua
mnt-by:         RIPE-DB-MNT
created:        2020-10-05T15:04:39Z
last-modified:  2020-10-05T15:04:39Z
source:         RIPE

% This query was served by the RIPE Database Query Service version 1.102.2 (BLAARKOP)
```

## AS35004: Branch Enterprise "Netgroup-Service"

ASN Name: NETGRUP

* IPv4 Addresses: 4,352
* Number of Peers: 6
* Number of Prefixes: 8
* ASN Allocated: 17th May 2005

### Links

* https://bgp.he.net/AS35004
* https://whois.ipip.net/AS35004
* https://bgpview.io/asn/35004

### Prefixes
```
Country 	Announced Prefix 	Description 	Valid ROA 	Parent Prefix
Ukraine (UA) Flag 	45.131.164.0/24 	NG_users 		45.131.164.0/22
Ukraine (UA) Flag 	45.131.166.0/24 	NG_users 		45.131.164.0/22
Ukraine (UA) Flag 	93.170.116.0/22 	PE Olexandr Vasilyevich Polishchuk 		93.170.0.0/15
Ukraine (UA) Flag 	93.170.118.0/24 	PE Olexandr Vasilyevich Polishchuk 		93.170.0.0/15
Ukraine (UA) Flag 	185.183.110.0/23 	PRIVATE JOINT STOCK COMPANY "DATAGROUP" 		185.183.108.0/22
Ukraine (UA) Flag 	194.126.180.0/22 	Branch Enterprise "Netgroup-Service" 		194.126.180.0/22
Ukraine (UA) Flag 	195.74.72.0/24 	Branch Enterprise "Netgroup-Service" 		195.74.72.0/24
Ukraine (UA) Flag 	195.162.80.0/22 	Netgrup route object 		195.162.80.0/22
```

### Summary
```
AS35004 Summary
Regional Registry: RIPE
Allocation Status: Allocated
Allocation Date: 17th May 2005
Allocated Country: Russian Federation (RU) Flag
Traffic Ratio: Not Disclosed
Website: http://netgroup.ua
AS35004 Network
IPv4 Prefixes: 8
IPv4 Peers: 6
IPv4 Upstreams: 2
IPv6 Prefixes: 0
IPv6 Peers: 0
IPv6 Upstreams: 0
Contacts
Email Contacts:
admin@com.if.ua
office@com.if.ua
Abuse Contacts:
admin@com.if.ua
Address:
Ivano-Frankovsk,
Ukraine
```

### Whois
```
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Information related to 'AS35004'

% Abuse contact for 'AS35004' is 'admin@com.if.ua'

aut-num:        AS35004
as-name:        NETGRUP
import:         from AS29632 action pref=100; accept ANY
import:         from AS15645 action pref=90; accept AS-UAIX
export:         to AS15645 announce AS-NETGRUP
export:         to AS29632 announce AS-NETGRUP
export:         to AS12883 announce AS-NETGRUP
import:         from AS12883 action pref=100;accept ANY
import:         from AS13249 action pref=100; accept ANY
export:         to AS13249 announce AS-NETGRUP
export:         to AS21219 announce AS-NETGRUP
import:         from AS39297 action pref=100; accept ANY
import:         from AS49706 action pref=100; accept ANY
import:         from AS21219 action pref=100; accept ANY
import:         from AS40972 action pref=100; accept ANY
import:         from AS57049 action pref=100; accept ANY
import:         from AS42066 action pref=100; accept ANY
import:         from AS57519 action pref=100; accept ANY
import:         from AS39680 action pref=100; accept AS39680
org:            ORG-BE14-RIPE
admin-c:        AB1811-RIPE
tech-c:         AB1811-RIPE
status:         ASSIGNED
mnt-by:         RIPE-NCC-END-MNT
mnt-by:         NETGRUP-MNT
created:        2005-05-17T09:26:00Z
last-modified:  2019-09-20T13:02:48Z
source:         RIPE
sponsoring-org: ORG-SL878-RIPE

organisation:   ORG-BE14-RIPE
org-name:       Branch Enterprise "Netgroup-Service"
org-type:       OTHER
address:        Ivano-Frankovsk, Ukraine
e-mail:         office@com.if.ua
abuse-c:        AR30053-RIPE
mnt-ref:        NETGRUP-MNT
mnt-by:         NETGRUP-MNT
created:        2010-03-23T15:37:25Z
last-modified:  2014-11-17T22:45:51Z
source:         RIPE

person:         Andrew Belocur
address:        13, Gryhevsky Str.
address:        Ivan-Frankivsk, Ukraine
phone:          +380 34 2595146
phone:          +380 34 2595145
e-mail:         office@com.if.ua
nic-hdl:        AB1811-RIPE
mnt-by:         NETGRUP-MNT
created:        2005-05-12T10:56:53Z
last-modified:  2010-01-26T00:02:56Z
source:         RIPE

% This query was served by the RIPE Database Query Service version 1.102.2 (HEREFORD)
```

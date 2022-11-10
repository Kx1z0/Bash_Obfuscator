# Bash_Obfuscator
The purpose of this tool is to give the Red Team on a Linux system the following capabilities:
- Ability to bypass static detections.
- The ability to execute commands with the capability of not being able to know which command was executed.
- Obfuscate scripts. (In development)
- A cool way to execute commands?  

I presented this tool at the cybersecurity event: [Bitup 2022](https://twitter.com/bitupalicante). You can watch the recording of my talk at the following YouTube video: [Video](https://www.youtube.com/watch?v=X5QKHX6weuc&t=3847s). In it I explain from 0 how the tool works underneath and what it is based on to do the obfuscation.

# Installation & Requirements
- `sudo apt-get install xclip`
- `chmod +x b4sh_0bfuscator.sh`

To ensure the correct functioning of the tool, always run it in a **Bash shell.**

# Warning
Not all special characters are added to the script. Characters currently implemented in the script: `Space  . / & " ; - | >`

In case you need to use a special character that is not included by default, you can simply do it in the following way:

In the following example, we can see the steps to follow in the case we want to add the character `_` 
1. Let's use the following piece of code:
```
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=Replace this=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc 'Replace this') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=Replace this=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="Replace this:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"
```
2. Replace in the 4 positions where it says "Replace this" by the character `_`. So that it looks like this:
```
espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=_=]' | fold -w ${1:-35} | head -n 1)

while [[ $(echo "$espacio_abecedario" | grep -oc '_') == 0 ]]; do
	espacio_abecedario=$(cat /dev/urandom | tr -dc '[:alnum:][=_=]' | fold -w ${1:-35} | head -n 1)
done

rand=$[ $RANDOM % $lineas ]
letra_mas_ruta="_:$espacio_abecedario"	
paths_finales+=( "$letra_mas_ruta" )
echo "$letra_mas_ruta"
```
**Keep in mind that depending on the character that you add, you may or may not have to escape it.**

3. For it to work properly, this code has to be appended to two parts of the script:
- At the end of the script, between the added default characters and the call to the obfuscation function.
- At the end of the renw_main() function, between the default characters added and the call to the function renw_obfuscation.

If you have any questions about the process, you can PM me on [Twitter](https://twitter.com/kx1z0) and I will be pleased to help you.:smile:

# Improvements
- We use a for loop in the final payload to hide how many characters the command has and the positions of the characters.
- Space at the beginning of the payload to prevent the command from being saved in the bash history.
- Autocopy payload to clipboard

# OpSec
You can hide the input of the key changing `read -p "Clave: " random_name` for `read -s random_name`

# Usage
We run the script: `./b4sh_0bfuscator.sh` (There is no need to run the script on the victim machine, we can generate the payloads on our attacker machine and paste them on the victim machine.)
```
[*]Dictionary[*]
a:Spshz1VlEsT8EKVImvOlrlTnsz80wKArasJ
b:iKSRR3rVBNQGLGiAwdW1pbZCswILn5xAALf
c:Ke4ijUIJuv06JRT36Az9Q8JQJdSKnukPdc1
d:jE5fy3ItQJFIoh0svRywQQUgMdiVKbioUUd
e:zDTYkr2nRbrwRrlnpC7042Bn4X6eHeC6VAV
f:8tG7RIRkLW2vefMVavJyst5PWqSI7DDk9fa
g:oAMFCAEgQ8U0Ii3njcmjs4NcwVIDIJVQ2kX
h:aaPMr6Nthyfne2PDBCwJZ6mu99jREWfgcOq
i:er61EcKF26WOjoZQIhAYmQGj19ngeYR5Bin
j:mcErcLA0jkS6PseA2ExZqa6RwaJ9B8pGmH7
k:kMySUumR4kR8MgEP0Rz3Gvpb8xQmK6fK2Op
l:ysXEOKFVkPwtoZYaxTR7Pl0TC4xPiHO6MdP
m:0icmUfOcVreBjFfhwbKxCBZDpaQLhuLoWJ3
n:ul0wdHPIlomQQSwp60wcnJGYBrdBU0AQh1g
o:llvxiRox6Jl8Rf35DxSJ0vGAxs6q1qimkq5
p:fdT17PmQ3pVbWIhiQVMqUzbg48eXdMmEuRn
q:a3zu5SXvwg2D2SWGWsqNY7wxiyAvOc54yWM
r:LbdlzZpMfvAvtKzonr2uPKEgcVh4yp1fYfQ
s:LTFMesAZ0m2MUMh5xuL1v5WUh1jLAi04UzW
t:RpofElUZW6kdwagrLsAet2oVsdZD7p0yEfe
u:Gk9uin0ZPNgLL4BzXhyq3SGEBNWWmbnVF5C
v:PBZVOmM5JfdayVhvmNrlDRFL9SQz06GbvPE
w:VG5q2XgrM58Vc9CDvuG7x6pwPCMHwUbMwih
x:kMySUumR4kR8MgEP0Rz3Gvpb8xQmK6fK2Op
y:rxfa5fSi6WRZDZQUeU9zex5FZyuJOyTCbBi
z:ew7aohBRhtQSYCayMKEtEzwjVzAkXsdhb4V
A:Axttty6wwUrITeho58Z1K7AcFzYaWzepUtq
B:eRWTq6OPaRUxB0Dj9aspfUw7z9kMDhG7ran
C:9uv9m67k9qjoPzdjCwKaAzVOQ7aGGFz5TSN
D:llvxiRox6Jl8Rf35DxSJ0vGAxs6q1qimkq5
E:oAMFCAEgQ8U0Ii3njcmjs4NcwVIDIJVQ2kX
F:zvv3J0PnLcyeCfFvQnNzvSFs5glTnVpBD5r
G:mcErcLA0jkS6PseA2ExZqa6RwaJ9B8pGmH7
H:OFCC1r2Cg8TqDbGt0WMdPKd9gHfId796eL8
I:ASqt0FgxI5Uc8IK4oyL2K5NWvhSOnEGp0Bt
J:BWPf1Hwjr6D7eyb2Jh7BsGTGM5yApxx2lXU
K:hDBdm6bLHKNWq65Kr3udTy3XGthTRT60JOj
L:PBZVOmM5JfdayVhvmNrlDRFL9SQz06GbvPE
M:QYbX2aCJPYshBDKMtEREKQJbF2PmB2JUByn
N:a3zu5SXvwg2D2SWGWsqNY7wxiyAvOc54yWM
O:YYNBj7z383Bzx9k7AxP7O4YRnkRHRMfduW6
P:vWkmdePAedcFiKW7yGMmzSQsbmrIBMuiYNs
Q:IlNr8iuwQjqhKKSoNqtsEu3GiL4mrWLBv2W
R:ZkVHjsZkXc6rwLeuRsQgBi6mpntJOahDHkI
S:IlNr8iuwQjqhKKSoNqtsEu3GiL4mrWLBv2W
T:bMXPaTm0foMJKU2WF6CyDaPum85QAjWu9OB
U:pnFmHwmyU79EzvIChyhRCZK1bW06aFTNVO7
V:eaOSFrJbwYAOWfZM1uzV18oC5QSC2J68CcX
W:yZ1SrhdieajwHSJfV8kr5VLIhuZjI6W8m55
X:EMxsgMXoJAOIaTUoPKeDUvSVBro7Wqj032X
Y:arTF3KGmYz3R7gGIv9ChY5LyLrPEVL6yTnm
Z:k0ttCc5AgbRFlcmgDx7zizvmk5OPpzmrZel
0:Hp0aFyLlRtp9eRnK4E2NoK6g9mqULpVlnJE
1:6c8lazX6yHUSWmTEPhhjERfou1ygOaz5ZD6
2:nsc8GYd2kV3KPLfCKVQN0jvugHaOAxvM5ys
3:xlUpk6NuST8cUI03QANqDgJxvSzDZAvoku1
4:yc9GZkQCNBDbpTI8FeLQujBQDsZ3sij0Qz4
5:4APSVmYjlzbsCqk3XC5FS0jXWU3J977Rxa0
6:8nDAzLb2PERzF56vnaHIRN6l0legorPxuIE
7:fXh7w72vLzXd0Cb15gMkROEaQYOSuwC2TVZ
8:5AfMA3PgjGrKS3lWHvv1CK0gSQQTZ8ybQwP
9:cVbYP9PGKbq3L1k3BxSxt9nfZZJuE2HCp20
 :5CLeTHV4dAFbF63Y NIePC3xy Oc122CEzr
.:DYp62.LR6pF2CHpRGiFkEUuPX8UiW.NdpCJ
/:VIrfc9cdNLyrsnTjv3cHl/MKwAIEf0BvZCV
&:t17QMPQkSklim2fUPsB948bSS&3d1bCcO1e
":eM"vnrhTc5kACH5HPJo5rENU8TH5ZZT79ef
;:Nad1C02Khq73KG4lNXP6xW0EMxml2l2tO;j
-:lwm6BOjQ3R3d2ybV-9XruIiaIsaxlRo2E2P
|:DBFm|ZQXvLwyphEE1XTbdQPAKTO|2xCk|ak
>:bj7gx6maqcbsM1Q1xBV>4Uyg64dIxe6Y8bQ

[*]Obfuscation[*]
Char: a --> Char Ofuscado: ${"Spshz1VlEsT8EKVImvOlrlTnsz80wKArasJ":32:1}
Char: b --> Char Ofuscado: ${"iKSRR3rVBNQGLGiAwdW1pbZCswILn5xAALf":21:1}
Char: c --> Char Ofuscado: ${"Ke4ijUIJuv06JRT36Az9Q8JQJdSKnukPdc1":33:1}
Char: d --> Char Ofuscado: ${"jE5fy3ItQJFIoh0svRywQQUgMdiVKbioUUd":25:1}
Char: e --> Char Ofuscado: ${"zDTYkr2nRbrwRrlnpC7042Bn4X6eHeC6VAV":27:1}
Char: f --> Char Ofuscado: ${"8tG7RIRkLW2vefMVavJyst5PWqSI7DDk9fa":13:1}
Char: g --> Char Ofuscado: ${"oAMFCAEgQ8U0Ii3njcmjs4NcwVIDIJVQ2kX":7:1}
Char: h --> Char Ofuscado: ${"aaPMr6Nthyfne2PDBCwJZ6mu99jREWfgcOq":8:1}
Char: i --> Char Ofuscado: ${"er61EcKF26WOjoZQIhAYmQGj19ngeYR5Bin":33:1}
Char: j --> Char Ofuscado: ${"mcErcLA0jkS6PseA2ExZqa6RwaJ9B8pGmH7":8:1}
Char: k --> Char Ofuscado: ${"kMySUumR4kR8MgEP0Rz3Gvpb8xQmK6fK2Op":0:1}
Char: l --> Char Ofuscado: ${"ysXEOKFVkPwtoZYaxTR7Pl0TC4xPiHO6MdP":21:1}
Char: m --> Char Ofuscado: ${"0icmUfOcVreBjFfhwbKxCBZDpaQLhuLoWJ3":3:1}
Char: n --> Char Ofuscado: ${"ul0wdHPIlomQQSwp60wcnJGYBrdBU0AQh1g":20:1}
Char: o --> Char Ofuscado: ${"llvxiRox6Jl8Rf35DxSJ0vGAxs6q1qimkq5":6:1}
Char: p --> Char Ofuscado: ${"fdT17PmQ3pVbWIhiQVMqUzbg48eXdMmEuRn":9:1}
Char: q --> Char Ofuscado: ${"a3zu5SXvwg2D2SWGWsqNY7wxiyAvOc54yWM":18:1}
Char: r --> Char Ofuscado: ${"LbdlzZpMfvAvtKzonr2uPKEgcVh4yp1fYfQ":17:1}
Char: s --> Char Ofuscado: ${"LTFMesAZ0m2MUMh5xuL1v5WUh1jLAi04UzW":5:1}
Char: t --> Char Ofuscado: ${"RpofElUZW6kdwagrLsAet2oVsdZD7p0yEfe":20:1}
Char: u --> Char Ofuscado: ${"Gk9uin0ZPNgLL4BzXhyq3SGEBNWWmbnVF5C":3:1}
Char: v --> Char Ofuscado: ${"PBZVOmM5JfdayVhvmNrlDRFL9SQz06GbvPE":15:1}
Char: w --> Char Ofuscado: ${"VG5q2XgrM58Vc9CDvuG7x6pwPCMHwUbMwih":23:1}
Char: x --> Char Ofuscado: ${"kMySUumR4kR8MgEP0Rz3Gvpb8xQmK6fK2Op":25:1}
Char: y --> Char Ofuscado: ${"rxfa5fSi6WRZDZQUeU9zex5FZyuJOyTCbBi":25:1}
Char: z --> Char Ofuscado: ${"ew7aohBRhtQSYCayMKEtEzwjVzAkXsdhb4V":21:1}
Char: A --> Char Ofuscado: ${"Axttty6wwUrITeho58Z1K7AcFzYaWzepUtq":0:1}
Char: B --> Char Ofuscado: ${"eRWTq6OPaRUxB0Dj9aspfUw7z9kMDhG7ran":12:1}
Char: C --> Char Ofuscado: ${"9uv9m67k9qjoPzdjCwKaAzVOQ7aGGFz5TSN":16:1}
Char: D --> Char Ofuscado: ${"llvxiRox6Jl8Rf35DxSJ0vGAxs6q1qimkq5":16:1}
Char: E --> Char Ofuscado: ${"oAMFCAEgQ8U0Ii3njcmjs4NcwVIDIJVQ2kX":6:1}
Char: F --> Char Ofuscado: ${"zvv3J0PnLcyeCfFvQnNzvSFs5glTnVpBD5r":14:1}
Char: G --> Char Ofuscado: ${"mcErcLA0jkS6PseA2ExZqa6RwaJ9B8pGmH7":31:1}
Char: H --> Char Ofuscado: ${"OFCC1r2Cg8TqDbGt0WMdPKd9gHfId796eL8":25:1}
Char: I --> Char Ofuscado: ${"ASqt0FgxI5Uc8IK4oyL2K5NWvhSOnEGp0Bt":8:1}
Char: J --> Char Ofuscado: ${"BWPf1Hwjr6D7eyb2Jh7BsGTGM5yApxx2lXU":16:1}
Char: K --> Char Ofuscado: ${"hDBdm6bLHKNWq65Kr3udTy3XGthTRT60JOj":9:1}
Char: L --> Char Ofuscado: ${"PBZVOmM5JfdayVhvmNrlDRFL9SQz06GbvPE":23:1}
Char: M --> Char Ofuscado: ${"QYbX2aCJPYshBDKMtEREKQJbF2PmB2JUByn":15:1}
Char: N --> Char Ofuscado: ${"a3zu5SXvwg2D2SWGWsqNY7wxiyAvOc54yWM":19:1}
Char: O --> Char Ofuscado: ${"YYNBj7z383Bzx9k7AxP7O4YRnkRHRMfduW6":20:1}
Char: P --> Char Ofuscado: ${"vWkmdePAedcFiKW7yGMmzSQsbmrIBMuiYNs":6:1}
Char: Q --> Char Ofuscado: ${"IlNr8iuwQjqhKKSoNqtsEu3GiL4mrWLBv2W":8:1}
Char: R --> Char Ofuscado: ${"ZkVHjsZkXc6rwLeuRsQgBi6mpntJOahDHkI":16:1}
Char: S --> Char Ofuscado: ${"IlNr8iuwQjqhKKSoNqtsEu3GiL4mrWLBv2W":14:1}
Char: T --> Char Ofuscado: ${"bMXPaTm0foMJKU2WF6CyDaPum85QAjWu9OB":5:1}
Char: U --> Char Ofuscado: ${"pnFmHwmyU79EzvIChyhRCZK1bW06aFTNVO7":8:1}
Char: V --> Char Ofuscado: ${"eaOSFrJbwYAOWfZM1uzV18oC5QSC2J68CcX":19:1}
Char: W --> Char Ofuscado: ${"yZ1SrhdieajwHSJfV8kr5VLIhuZjI6W8m55":30:1}
Char: X --> Char Ofuscado: ${"EMxsgMXoJAOIaTUoPKeDUvSVBro7Wqj032X":6:1}
Char: Y --> Char Ofuscado: ${"arTF3KGmYz3R7gGIv9ChY5LyLrPEVL6yTnm":8:1}
Char: Z --> Char Ofuscado: ${"k0ttCc5AgbRFlcmgDx7zizvmk5OPpzmrZel":32:1}
Char: 0 --> Char Ofuscado: ${"Hp0aFyLlRtp9eRnK4E2NoK6g9mqULpVlnJE":2:1}
Char: 1 --> Char Ofuscado: ${"6c8lazX6yHUSWmTEPhhjERfou1ygOaz5ZD6":25:1}
Char: 2 --> Char Ofuscado: ${"nsc8GYd2kV3KPLfCKVQN0jvugHaOAxvM5ys":7:1}
Char: 3 --> Char Ofuscado: ${"xlUpk6NuST8cUI03QANqDgJxvSzDZAvoku1":15:1}
Char: 4 --> Char Ofuscado: ${"yc9GZkQCNBDbpTI8FeLQujBQDsZ3sij0Qz4":34:1}
Char: 5 --> Char Ofuscado: ${"4APSVmYjlzbsCqk3XC5FS0jXWU3J977Rxa0":18:1}
Char: 6 --> Char Ofuscado: ${"8nDAzLb2PERzF56vnaHIRN6l0legorPxuIE":14:1}
Char: 7 --> Char Ofuscado: ${"fXh7w72vLzXd0Cb15gMkROEaQYOSuwC2TVZ":3:1}
Char: 8 --> Char Ofuscado: ${"5AfMA3PgjGrKS3lWHvv1CK0gSQQTZ8ybQwP":29:1}
Char: 9 --> Char Ofuscado: ${"cVbYP9PGKbq3L1k3BxSxt9nfZZJuE2HCp20":5:1}
Char:   --> Char Ofuscado: ${"5CLeTHV4dAFbF63Y NIePC3xy Oc122CEzr":16:1}
Char: . --> Char Ofuscado: ${"DYp62.LR6pF2CHpRGiFkEUuPX8UiW.NdpCJ":5:1}
Char: / --> Char Ofuscado: ${"VIrfc9cdNLyrsnTjv3cHl/MKwAIEf0BvZCV":21:1}
Char: & --> Char Ofuscado: ${"t17QMPQkSklim2fUPsB948bSS&3d1bCcO1e":25:1}
Char: " --> Char Ofuscado: ${"eM"vnrhTc5kACH5HPJo5rENU8TH5ZZT79ef":2:1}
Char: ; --> Char Ofuscado: ${"Nad1C02Khq73KG4lNXP6xW0EMxml2l2tO;j":33:1}
Char: - --> Char Ofuscado: ${"lwm6BOjQ3R3d2ybV-9XruIiaIsaxlRo2E2P":16:1}
Char: | --> Char Ofuscado: ${"DBFm|ZQXvLwyphEE1XTbdQPAKTO|2xCk|ak":4:1}
Char: > --> Char Ofuscado: ${"bj7gx6maqcbsM1Q1xBV>4Uyg64dIxe6Y8bQ":19:1}

Command: whoami
Encryption key: 1234
 read -p "Key: " THZ6Nk9sCg ; bmlEOTlTCg="$(echo U2FsdGVkX18bAONNR6x5qN2hcEHZKlTBzazqIsQgOg0O4yXo7WCbmHxisZGB9Dfh4wBSzqoDA2Pqixqi//oESHrb4tR0iGcE+lNUcRJgjkYHUU+XMF5IMfLXualOf4/7nZEkhxTkOq0FYpQmSzJBeS/EtKPA0i7zcMr671wUZ1Ti6kUL8FIwhRMsOa2Zra1phRTaeHseQpjIqqMP6ox61+PlXzVl81BZSzHOkPebsP0RfcE8VI7UNHv5Kei+GFRWg4k5JGc20lQHkXwMlwFQP6p1JrHBegvUYLEjLhQkt+Uvh1ClJzYwm34Z9BLirxNUZqZBcPOkQ+FYYLNcuzyIbQ== | base64 -d | openssl enc -in - -d -aes-256-cbc -pass pass:$THZ6Nk9sCg -pbkdf2)" ; bash -c "$(for cXZtcDZqCg in $(echo $bmlEOTlTCg | awk -F"Y0J4QlEK" '{print $2}') ; do echo -n "${bmlEOTlTCg:cXZtcDZqCg:1}"; done)" ; unset THZ6Nk9sCg bmlEOTlTCg cXZtcDZqCg

```
The payload will be automatically copied to the clipboard, just paste it and run it.

# Example
Youtube Video (Click on the image to be redirected to Youtube):


[![Alt text](https://img.youtube.com/vi/szFiXRN8nEA/0.jpg)](https://www.youtube.com/watch?v=szFiXRN8nEA)

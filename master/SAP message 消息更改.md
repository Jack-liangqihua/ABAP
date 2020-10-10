# SAP消息修改
```
FI: OBA5|OFMG|OFPM

CO: OPR4_ACT|OPR4_CK|OPR4_CKML|OPR4_CKPF|OPR4_KKA|OPR4_KKP|OPR4_KKS|

OPR4_KKS1|OPR4_PPCOPP

MM: OMRM|OKZZ|OMT4|OMCQ |O04C|

SD: OVAH

Others: OPR5|OPR1|OPR3|OPR6|OPR7|OPR8|OPR9|OPRCMFE|MSW1|MSW2
```
SAP修改消息内容和报错类型（OBA5)
SAP消息也是这样,你可将所有能忽略的消息ignore让它鞠躬尽瘁死而后已为你工作.

从是否允许你configure层次分两种: configurable和non-configurable.
对configurable message可选的message type通常有S, I, W, E, A，-
(online表示即时output message -表示switch off message继续做后面工作 batchi表示做batch input时).
就是说对configurable message SAP允许你设置它是Error, warning或者switch off干脆忽略,通常这些个
错误不至于引起致命的系统逻辑错误.


## 一.基本概念
你可简单理解为消息是SAP为exception预警的一种手段.
Application area:告诉你消息归属,分类吧.其实就是SE91所说的Message class

## 二:消息相关最常用的table:
```
T100: SAP default Message,
T160M :Message Control: Purchasing (System Messages)
T100C: User_defined messaeg mainly for FI
TVGMS: View Control
T100S: Configurable system messages
T100W: For Workflow
T100U: 最后更改消息的user table
T5CBN: PC Operation Conditions
 
-------------------------------------------
需要指出的是你必须注意做重要的三个表
T100:包含所有的message
T100C:你定义的message通常将出现在此表
T100s:Configurable system messages顾名思义就是你能设置的消息.
比如OBA5你想设置F5 060消息,这个是FB50在balance<>0你想强行save弹出的,在T100s
中你将看到F5 060不在其中,因为这是将影响财务的致命错误,当然OBA5是不允许你去设置的.
**欺骗SAP使用OBA5强行Switch off F5 060.
-----------------------------------------------------

``` 
## 三.建立查询消息.
T-code:SE91
你可为自己的程序和Enhancement编写消息.
通常在程序中你能看到类似.
```
CALL FUNCTION 'READ_CUSTOMIZED_MESSAGE'
EXPORTING
i_arbgb = i_arbgb
i_dtype = i_dtype
i_msgnr = i_msgnr
IMPORTING
e_msgty = l_msgts.
```
IF l_msgts NE '-'.(如果没switch off)
然后就是提示. 然后去读T100C 用户自定的messge type(Error,warnig, error0决定是否继续work.


## 四.设置消息(这个应该对大家有点用处)

相关T-code:(**很多是雷同的)
### FI 部分:
```
OBA5:FI messge
BD60:Additional data for message type
OFMG:FOr FM Message
O04C:PI: Message Control Purchasing
OFPM:Change Message Control
OMPJ:Reqmts Type Message Control
F00-->***这个是send office message
KD99:setup message
KDNN:Setup messaeg

```
### MM-PUR部分:
O04C:For purchase
OKZZ:Invoice Verification/Valuation
```

### CO部分:
```
OPR4_ACT Multilevel Actual Settlement
OPR4_CK Material Cost Estimate
OPR4_CKML Closing and Calc. of Periodic Price
OPR4_CKPF Price Update
OPR4_KKA WIP Calculation
OPR4_KKP Repetitive Mfg and Process Mfg
OPR4_KKS Collective Processing: Variances
OPR4_KKS1 Individual Processing: Variances
OPR4_PPCO Production Order: Cost Calculation
OPR5 Definition of Error Mgmt IDs (SAP)
OPR1 Area of Responsibility <-> Message
OPR3 Definition of Breakpoints
OPR6 Definition of Object IDs (SAP)
OPR7 Def. of Areas of Responsibility
OPR8 Def. of Minimum Message Types (SAP)
OPR9 Def. of Reference Objects (SAP)
OPRCMFE User-Defined Messages
```
### SD部分"
```
OVAH :SD Define Variable Messages
------------------------------------------------------------
SAP允许用户修改的消息都save在T100S中,你配置后的消息从T100C可看到
但是如果我将不允许的消息强行coding塞进去,会有什么后果呢?
-------------------------------------------------------------

***严格地将下面的T-code多是设置output打印的.
M/30 Maintain Types: RFQ
M/32 Maint. Determ. Schema: RFQ
M/34 Maintain Types: PO
M/36 Maintain Determ. Schema: PO
M/38 Maint. Types: Outline Agmt.
M/40 Maint. Types: Del. Schedule
M/42 Maintain Schema: Del. Sched.
M/48 Maintain Access Sequences: RFQ
M/50 Maintain Access Sequences: PO
M/56 s: Create Cond. Table: RFQ
M/57 s: Change Condition Table
M/58 s: Display CondTab: RFQ
M/59 s: Create CondTab: Pur. Order
M/60 s: Change CondTab: Pur. Order
M/61 s: Disp. CondTab: Pur. Order
M/62 s: Create CondTab: Del. Schd.
M/63 s: Change CondTab: Del. Schd.
M/64 s: Disp. CondTab: Del. Sched.
M/65 s: Create CondTab: O. Agmt.
M/66 s: Change CondTab: O. Agmt.
M/67 s: Disp. CondTab: Outl. Agmt.
M/68 Maintain Schema: Outl. Agmt.
M/70 s: Create CondTab.: Entry Sh.
M/71 s: Change CondTab.: Entry Sh.
M/72 s: Disp. CondTab.: Entry Sh.
M/73 Maintain Access Sequences: Entry
M/74 Maintain Access Sequences: Entry
M/75 Maintain s: Serv. Entry Sheet
M/76 Display s: Entry
M/77 Maintain Schema: Entry Sheet
M/78 Disp. Determ. Schema: Entry
M/N1 Maintain accesses (fr.gds - purch.)
```

## 五.重置警告消息.
```
将消息warning change to display显示.
MSW1 Reset Warnings
MSW2 Reset Warnings
```
## 六附录: Message_related tables:(部分)
```
T100: All message
T100A: IDs for T100
T100C: Control by User
T100O: Assignment of to object
T100S: Configurable system s
T100SA: Application Areas for Configurable s
T100U: Last person to change s
T100V: Assignment of s to tables/views
T100W: Assign s to Workflow
T100X: Error s: Supplements
T139A: Exception s: Period Closing Program
T139B: Exception s: Period Closing Program
T159F: MMIM: Error s Resulting From Blocked Objects
T160M: Control: Purchasing (System s)
T160MVAL: category restriction for T160M
T161M: Fine-Tuned Control: Types
T161N: Determination Schemas: Assignment
T321K: Definition of Accumulated s to HOST (R/2)
T323P: Parameters for Generating Logs and Mail s (R/2->R/3)
T440F: Exception s for the forecast
T458A: Exception s in Material Requirements Planning
T458B: Description of exception s
T458C: Selection Group for Exception s
T555E: Time Evaluation s
T5CAR: for Employee Attribute Combination
T5CBN: s for PC Operation Conditions
T5D5D: Supplementary Benefits for Civil Service: Fields
T5D5E: Supplemenary Bens. for Civil Service: Reason Table
T5E31: Actions and situations for registration s
T5F6N: Global Error s.
T5F6NN: Communication of Error s (ADP Interface)
T5MP1: General s for the PBS Remuneration Statement
T5QGM: Payroll Highlight s Australia
T5QGT: s Area Check Table Australia
T5QSM: Superannuation Highlight s Australia
T5S0S: s for sickness administration (SE)
T5V5M: s sent electronically to AA-registeret
T5V7B: s sent to employees/emplyoers register
T7NZGM: Payroll Highlight s NZ
T7NZSM: Superannuation Highlight s NZ
TA20PPZ: handling: chosen priority with top priority
TA20PPZ1: handling (language-dependent)
TA22RSF: START: Error s
TA22RSF1: START: Error s (Language-Dependent)
TAFWD: CORU: s that are not interpreted as errors
TBD05: Distribution model for types
TBD12: Mapping type -> serialization and link type
TBD14: type -> object type
TBD17: Dependencies between types
TBD33: Dependencies between methods and types
TBD40: Assign Types to Serialization Group
TBD53: ALE: Object Channel Serialization: Type of Bus. Obj.
TBD62: Assignment of change document field to type
TBDA2: ALE active
TBDME: ALE supplement data for EDI type
TBDMS: Assignment of type to IDoc type
TBDTPM: Template for Type
TBDTPMD: Data Filters for Types
TC50: PP-PI: Proc. Categories/ Proc.Instruction Categories
TC50A: Assignment of Charact. to Dest.-Spec. Target Fields
TC50C: Characteristics for Process s / Process Instructions
TC50D: Process Management: Destinations
TC50P: Characteristics for Dest.-Specific Target Fields
TC50T: Process /Instr. Categories: Lang.-Dependent Texts
TC51T: Destinatiosn: Language-Dependent Texts
TC53: Characteristics Groups for Process s and Instructions
TC55: Destination-Specific Target Fields for Destinations
TCA10: Task lists: s depending on the task list type
TCB02: Types of Destination
TCB02T: Types of Destination: Language-Dependent Texts
TCB10: Predefined Proc. Categories/Proc. Instr. Categories
TCB10T: Predefined Categories: Language-Dependent texts
TCB11: Assignment of Characteristics to Predefined s
TCB12T: Predefined Destinations: Language-Dependent Texts
TCB13: Target Fields for Predefined Destinations
TCB13T: Target Fields for Predef. Destin.: Lang-Dep. Texts
TCB14: Predefined Assignments of Destinations to Categories
TCB16: Predefined Charact. Groups for and Instruction Cat.
TCB18: PP-PI-PMA: System Settings for Process Processing
TCMF1: Assignment: Area of Responsibility <->
TCMF9: Minimum Type (SAP)
TCMFA: User-Defined s
TCOINF: Displaying Info. in Monitor / Ctrl Recipe Monitor
TCPT1: Code pages: Table 1 for tests and s
TCUSSYSL: Summary table of types read from the system log
TCY43: s for flow control
TCY43T: Texts for s for flow control
TDSP01: ALE Distribution Packet : Types to be Controlled
TEMSG: System s
TEMSI: Central ID assignment for Express s
TMAN1: Trigger Condition of Determination
TMAN2: Trigger Group of Determination
TMAN2T: Trigger Group of Determination - Description
TMAN3: Trigger Group of Determination - Trigger Condition
TMAN4: Trigger Conditions s - Change-Relevant Tables
TMAN5: Trigger Conds s; Possible Change-Relevant Fields
TMAN6: Trigger Conds s: Change-Rel. Tbl per Object+ChangeTyp
TMAN7: Trigger Conditions - Applications
TMSG1: Logical s and Process Codes in Outb. Procg
TMSG2: Logical s and Process Codes in Inb. Procg
TMSQAMTREE: TMS: Assigning to Tree Nodes in the Alert Monitor
TMSQAMTRET: TMS: Assigning to Tree Nodes in Alert Monitor- Texts
TNODE02_AP: Test case attributes: Problem data
TOPRK: Log s
TPT_WLIST_AREA: Processing: Functional Area
TPT_WLIST_AREA_T: Processing: Functional Area Text
TPT_WLIST_PROC: Processing: Methods
TPT_WLIST_PROC_T: Processing: Processing Method Text
TRMSG: Syntax Check Error s
TSL1D: System Log (Formerly 100S or TSL01)
TSL1T: System Log: texts (Formerly T100S, TSL01)
TSL2D: System Log: Classification ID for s
TSL2T: System Log: Class Names
TVERR: Basis verification: Infos for s to be sent
TVGMS: View Control: Error s
TWPDO: Assignment of retail to PD org. object
TXMIMSG: Table for Lang.-Depend. Texts in XMI Log
TZ38T: Text table for indicator reason for appendix 8 R5/97
TZW02: User <-> Determine
WFMCMSGENQ: Special Handling for System s
WPXST: POS interface: status external subsystems (error s)
WRPE: Replenishment: Error s
WTMIGMESS: s Logged for Withholding Tax Changeover
WTMIGMESSEXC: Withholding Tax Changeover: Alternative Types
```
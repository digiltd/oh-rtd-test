# Documentation of the Systeminfo binding Bundle

# Introduction

System information binding provides operating system monitoring data including:

- System memory, swap, cpu, load average, uptime
- Per-process memory, cpu
- File system metrics
- Network interface metrics

Binding use Hyperic SIGAR API to access system information regardless of the underlying platform (Windows, Linux, OS X...). 

For installation of the binding, please see Wiki page [[Bindings]].

# Generic Item Binding Configuration

openhab.cfg file (in the folder '${openhab_home}/configurations').

    ############################### Systeminfo Binding ####################################
    #
    # Interval in milliseconds when to find new refresh candidates
    # (optional, defaults to 1000)
    #systeminfo:granularity=
    
    # Data Storage Unit, where B=Bytes, K=kB, M=MB, T=TB (optional, defaults to M)
    #systeminfo:units=

# Hyperic SIGAR Native libraries

The SystemInformation binding does not include SIGAR native libraries currently. The platform dependent Sigar native libraries needs to be moved into the ${openhabhome]/lib folder. Pre builded libraries can be found [here](http://sourceforge.net/projects/sigar/files/sigar/1.6/hyperic-sigar-1.6.4.tar.gz/download) for several platforms (see sugar-bin/lib folder).

# Item Binding Configuration

In order to bind an item to the device, you need to provide configuration settings. The easiest way to do so is to add some binding information in your item file (in the folder configurations/items`). The syntax of the binding configuration strings accepted is the following:

    systeminfo="<commandType>:<refreshPeriod>(<target>)"

Where 

{{{<commandType>}}} corresponds the command type. See complite list below.

{{{<refreshPeriod>}}} corresponds update interval of the item in milliseconds.

{{{<target>}}} corresponds target of the command. Target field is mandatory only for commands, which need target. See further details from supported command list below.

# List of supported commands (commandType)

<table>
  <tr><td>**Command**</td><td>**Item Type**</td><td>**Purpose**</td><td>**Note**</td></tr>
</table>
|| LoadAverage1Min || Number ||  ||  || 
|| LoadAverage5Min || Number ||  ||  || 
|| LoadAverage15Min || Number ||  ||  || 
|| CpuCombined || Number ||  ||  || 
|| CpuUser || Number ||  ||  || 
|| CpuSystem || Number ||  ||  || 
|| CpuNice || Number ||  ||  || 
|| CpuWait || Number ||  ||  || 
|| Uptime || Number ||  ||  || 
|| UptimeFormatted || String ||  ||  || 
|| MemFree || Number ||  ||  || 
|| MemFreePercent || Number ||  ||  || 
|| MemUsed || Number ||  ||  || 
|| MemUsedPercent || Number ||  ||  || 
|| MemActualFree || Number ||  ||  || 
|| MemActualUsed || Number ||  ||  || 
|| MemTotal || Number ||  ||  || 
|| SwapFree || Number ||  ||  || 
|| SwapTotal || Number ||  ||  || 
|| SwapUsed || Number ||  ||  || 
|| SwapPageIn || Number ||  ||  || 
|| SwapPageOut || Number ||  ||  || 
|| NetTxBytes || Number ||  || target = net interface name (1 || 
|| NetRxBytes || Number ||  || target = net interface name (1 || 
|| DiskReads || Number ||  || target = disk name (2 || 
|| DiskWrites || Number ||  || target = disk name (2 || 
|| DiskReadBytes || Number ||  || target = disk name (2 || 
|| DiskWriteBytes || Number ||  || target = disk name (2 || 
|| DirUsage || Number ||  || target = directory path (if folder contains lot of files scan can take a while!)|| 
|| DirFiles || Number ||  || target = directory path (if folder contains lot of files scan can take a while!)|| 
|| ProcessRealMem || Number ||  || target = process name (3 || 
|| ProcessVirtualMem || Number ||  || target = process name (3 || 
|| ProcessCpuPercent || Number ||  || target = process name (3 || 
|| ProcessCpuSystem || Number ||  || target = process name (3 || 
|| ProcessCpuUser || Number ||  || target = process name (3 || 
|| ProcessCpuTotal || Number ||  || target = process name (3 || 
|| ProcessUptime || Number ||  || target = process name (3 || 
|| ProcessUptimeFormatted || String ||  || target = process name (3 || 
|| ProcessCpuPercent || Number ||  || target = process name (3 || 

(1 interface name:
Check supported interface names by ifconfig, ipconfig or openhab debug log E.g. "21:56:12.930 DEBUG o.o.b.s.internal.SysteminfoBinding[- valid net interfaces: [lo0, en0, en1, p2p0, vboxnet0](:479])

(2 disk name:
Check supported disk names by iostat or openhab debug log "21:56:12.931 DEBUG o.o.b.s.internal.SysteminfoBinding[- valid disk names: [/dev/disk0s2](:493])"

(3 process name supports:

<table>
  <tr><td>**Usage**</td><td>**Example**</td><td>**Explanatory**</td></tr>
  <tr><td>$$</td><td>$$</td><td>current process</td></tr>
</table>
|| processname || eclipse || process name contains "eclipse" || 
|| `**`processname || `**`eclipse || process name ends to "eclipse" ||
|| processname`**` || eclipse`**` || process name start with "eclipse" || 
|| =processname || =eclipse || process name equals "eclipse" || 
|| #PTQL || #State.Name.eq=eclipse || Sigar Process Table Query Language (see https://support.hyperic.com/display/SIGAR/PTQL) || 

Examples, how to configure your items:

    Number loadAverage1min	"Load avg. 1min [%.1f]"	(System) { systeminfo="LoadAverage1Min:5000" }
    Number loadAverage5min	"Load avg. 5min [%.1f]"	(System) { systeminfo="LoadAverage5Min:5000" }
    Number loadAverage15min "Load avg. 15min [%.1f]"	(System) { systeminfo="LoadAverage15Min:5000" }
    
    Number cpuCompined	"CPU combined [%.1f]"	(System) { systeminfo="CpuCombined:5000" }
    Number cpuUser	"CPU user [%.1f]"	(System) { systeminfo="CpuUser:5000" }
    Number cpuSystem	"CPU system [%.1f]"	(System) { systeminfo="CpuSystem:5000" }
    Number cpuNice	"CPU nice [%.1f]"	(System) { systeminfo="CpuNice:5000" }
    Number cpuWait "CPU wait [%.1f]"	(System) { systeminfo="CpuWait:5000" }
    
    Number uptime	"Uptime [%.1f]"	(System) { systeminfo="Uptime:5000" }
    String uptimeFormatted	"Update formatted [%s]"	(System) { systeminfo="UptimeFormatted:5000" }
    
    Number MemFree "Mem free [%.1f]"	(System) { systeminfo="MemFree:5000" }
    Number MemFreePercent	"Mem free [%.1f%%]"	(System) { systeminfo="MemFreePercent:5000" }
    Number MemUsed	"Mem used [%.1f]"	(System) { systeminfo="MemUsed:5000" }
    Number MemUsedPercent	"Mem used [%.1f%%]"	(System) { systeminfo="MemUsedPercent:5000" }
    Number MemActualFree	"Mem actual free [%.1f]"	(System) { systeminfo="MemActualFree:5000" }
    Number MemActualUsed	"Mem actual used [%.1f]"	(System) { systeminfo="MemActualUsed:5000" }
    Number MemTotal	"Mem total [%.1f]"	(System) { systeminfo="MemTotal:5000" }
    
    Number SwapFree	"Swap free [%.1f]"	(System) { systeminfo="SwapFree:5000" }
    Number SwapTotal	"Swap total [%.1f]"	(System) { systeminfo="SwapTotal:5000" }
    Number SwapUsed	"Swap used [%.1f]"	(System) { systeminfo="SwapUsed:5000" }
    Number SwapPageIn	"Swap pagein [%.1f]"	(System) { systeminfo="SwapPageIn:5000" }
    Number SwapPageOut	"Swap pageout [%.1f]"	(System) { systeminfo="SwapPageOut:5000" }
    
    Number NetTxBytes	"Next tx bytes [%.1f]"	(System) { systeminfo="NetTxBytes:5000:en1" }
    Number NetRxBytes	"Next rx bytes [%.1f]"	(System) { systeminfo="NetRxBytes:5000:en1" }
    
    Number DiskReads	"Disk reads [%.1f]"	(System) { systeminfo="DiskReads:5000:/dev/disk1" }
    Number DiskWrites	"Disk writes [%.1f]"	(System) { systeminfo="DiskWrites:5000:/dev/disk1" }
    Number DiskReadBytes	"Disk read bytes [%.1f]"	(System) { systeminfo="DiskReadBytes:5000:/dev/disk1" }
    Number DiskWriteBytes	"Disk write bytes [%.1f]"	(System) { systeminfo="DiskWriteBytes:5000:/dev/disk1" }
    
    Number DirUsage	"Dir usage [%.1f]"	(System) { systeminfo="DirUsage:5000:/Users/foo" }
    Number DirFiles	"Dir files [%.1f]"	(System) { systeminfo="DirFiles:5000:/Users/foo" }
    
    Number OpenhabRealMem	"Real mem [%.1f]"	(System) { systeminfo="ProcessRealMem:5000:$$" }
    Number OpenhabVirtualMem	"Virtual mem [%.1f]"	(System) { systeminfo="ProcessVirtualMem:5000:$$" }
    Number OpenhabCpuPercent	"Cpu percent [%.1f%%]"	(System) { systeminfo="ProcessCpuPercent:5000:$$" }
    Number OpenhabCpuSystem	"CPU system [%.1f]"	(System) { systeminfo="ProcessCpuSystem:5000:$$" }
    Number OpenhabCpuUser	"CPU user [%.1f]"	(System) { systeminfo="ProcessCpuUser:5000:$$" }
    Number OpenhabCpuTotal	"CPU total [%.1f]"	(System) { systeminfo="ProcessCpuTotal:5000:$$" }
    Number OpenhabUptime	"Uptime [%d]"	(System) { systeminfo="ProcessUptime:5000:$$" }
    String OpenhabUptimeFormatted	"Uptime form. [%s]"	(System) { systeminfo="ProcessUptimeFormatted:5000:$$" }
    
    Number EclipseRealMem1	"Real mem1 [%.1f]"	(System) { systeminfo="<ProcessCpuPercent:10000:eclipse" }
    Number EclipseRealMem2	"Real mem2 [%.1f]"	(System) { systeminfo="<ProcessCpuPercent:10000:*eclipse" }
    Number EclipseRealMem3	"Real mem3 [%.1f]"	(System)  { systeminfo="<ProcessCpuPercent:10000:eclipse*" }
    Number EclipseRealMem4	"Real mem4 [%.1f]"	(System) { systeminfo="<ProcessCpuPercent:10000:=eclipse" }
    Number EclipseRealMem5	"Real mem5 [%.1f]"	(System) { systeminfo="<ProcessCpuPercent:10000:#State.Name.eq=eclipse"
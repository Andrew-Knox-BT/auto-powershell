#Test WSMan connection on remote computer
Test-WSMan -ComputerName 10.200.114.67

#Test WSMan connection -Authentication will also return OS version. i.e. - ProductVersion  : OS: 10.0.19044 SP: 0.0 Stack: 3.0
Test-WSMan -Authentication default
Test-WSMan -Authentication default | fl *
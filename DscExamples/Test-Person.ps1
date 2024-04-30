Set-Location c:\MimDsc

#region Call the Set and Test methods directly - allows for setting a breakpoint for debuggering
Search-Resources -XPath "/Person" -ExpectedObjectType Person

ipmo MimDsc -Force
ipmo 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcPerson\MimSvcPerson.psm1' -Force
psedit 'C:\Program Files\WindowsPowerShell\Modules\MimDsc\DSCResources\MimSvcPerson\MimSvcPerson.psm1'

$resourceProperties = @{
    AccountName = "TestPerson$randomNumber"
    DisplayName = "Test Person $randomNumber"
    Domain      = 'Redmond'
    City        = 'Toronto'
    Email       = "TestPerson$randomNumber@litware.ca"
    EmployeeID  = '007'
    FirstName   = 'TestPerson'
    LastName    = $randomNumber
    Manager     = "TestPersonManager$randomNumber"
    ObjectSID   = [System.Convert]::ToBase64String($sidBytes)
    Ensure		= 'Present'
}

Test-MimSvcTargetResource -ObjectType Person -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

Set-MimSvcTargetResource -ObjectType Person -KeyAttributeName DisplayName -DscBoundParameters $resourceProperties -Verbose:$true

#endregion

#region: Test for an existing Person
$binarySid = (New-Object System.Security.Principal.NTAccount 'Everyone').Translate([System.Security.Principal.SecurityIdentifier])
$sidBytes = New-Object System.Byte[] -ArgumentList $binarySid.BinaryLength

$randomNumber = Get-Random -Minimum 100 -Maximum 999
$manager = New-Resource -ObjectType Person
$manager.AccountName = "TestPersonManager$randomNumber"
$manager | Save-Resource

$person = New-Resource -ObjectType Person
$person.AccountName = "TestPerson$randomNumber"
$person.DisplayName = "Test Person $randomNumber"
$person.Domain      = 'Redmond'
$person.City        = 'Toronto'
$person.Email       = "TestPerson$randomNumber@litware.ca"
$person.EmployeeID  = '007'
$person.FirstName   = 'TestPerson'
$person.LastName    = $randomNumber
$person.Manager     = $manager
$person.ObjectSID   = $sidBytes
$person | Save-Resource

Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Person $randomNumber"
            Domain      = 'Redmond'
            City        = 'Toronto'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '007'
            FirstName   = 'TestPerson'
            LastName    = $randomNumber
            Manager     = "TestPersonManager$randomNumber"
            ObjectSID   = [System.Convert]::ToBase64String($sidBytes)
            Ensure		= 'Present'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson" -Force
#endregion

#region: New Person
$randomNumber = Get-Random -Minimum 100 -Maximum 999

$manager = New-Resource -ObjectType Person
$manager.AccountName = "TestPersonManager$randomNumber"
$manager | Save-Resource

Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Person $randomNumber"
            Domain      = 'Redmond'
            City        = 'Toronto'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '007'
            FirstName   = 'TestPerson'
            LastName    = "$randomNumber"
            Manager     = "TestPersonManager$randomNumber"
            Ensure		= 'Present'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson" -Force
#endregion

#region: Update Person
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Person $randomNumber"
            Domain      = 'Redmond'
            City        = 'Toronto'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '007'
            FirstName   = 'Test'
            LastName    = "Person $randomNumber"
            Ensure		= 'Present'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson" -Force

Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Foo $randomNumber"
            Domain      = 'Redmond'
            City        = 'Issaquah'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '0077'
            FirstName   = 'Test'
            LastName    = "Person $randomNumber"
            Ensure		= 'Present'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson" -Force
#endregion

#region: Remove Person
$randomNumber = Get-Random -Minimum 100 -Maximum 999
Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Person $randomNumber"
            Domain      = 'Redmond'
            City        = 'Toronto'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '007'
            FirstName   = 'Test'
            LastName    = "Person $randomNumber"
            Ensure		= 'Present'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson" -Force

Configuration TestPerson 
{ 
    Import-DscResource -ModuleName MimDsc

    Node (hostname) 
    { 
        Person "TestPerson$randomNumber"
        {
            AccountName = "TestPerson$randomNumber"
            DisplayName = "Test Person $randomNumber"
            Domain      = 'Redmond'
            City        = 'Toronto'
            Email       = "TestPerson$randomNumber@litware.ca"
            EmployeeID  = '007'
            FirstName   = 'Test'
            LastName    = "Person $randomNumber"
            Ensure		= 'Absent'
        }
    } 
} 

TestPerson

Start-DscConfiguration -Wait -Verbose -Path "C:\MimDsc\TestPerson"
#endregion
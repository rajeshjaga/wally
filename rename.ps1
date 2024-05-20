<#
    .SYNOPSIS
        wallpaper file name cleaner
    .DESCRIPTION
        Clean the file name of the wallpaper in a folder
    .PATH
        Give me the path to wallpaper folder
    .CLEANUP
        cleanup the naming convention
    .RENAME
        Rename wallpaper files that don't start with wall, this will change any wallpaper name that doesstart with wall
    .EXAMPLE
        C:\Users\$USERNAME\Pictures> .\renamewall.ps1 -index C:\Users\$USERNAME\Pictures\wally
        The above invoking of the script should remove (, " ", ) in the filename of the wallies
    #>
[CmdletBinding(DefaultParameterSetName="Path")]

param(
    [Parameter(Mandatory=$true)]
    [String] $path
)
$fileExtension=@(".png",".jpeg",".jpg",".webp")
$others = @()
$filesTypes=[PSCustomObject]@{
    jpeg  = @()
    png = @()
    jpg = @()
    webp = @()
}
try
{
    $files = (Get-ChildItem -Path $path | Select-Object -ExpandProperty Name)
    if($files)
    {
        $files | ForEach-Object {
            if($PSItem.EndsWith($fileExtension[0]))
            {
                $filesTypes.png+=$PSItem
            } elseif($PSItem.EndsWith($fileExtension[1]))
            {
                $filesTypes.jpeg+=$PSItem
            } elseif($PSItem.EndsWith($fileExtension[2]))
            {
                $filesTypes.jpg+=$PSItem
            } elseif($PSItem.EndsWith($fileExtension[3]))
            {
                $filesTypes.webp+=$PSItem
            } else
            {
                $others+=$PSItem
            }
        }
    }
    if($null -ne $filesTypes.PSObject.Properties.Value)
    {
        # loop into the ftype of files
        $filesTypes.PSObject.Properties | ForEach-Object {
            # values of the file
            $value = $PSItem.value
            # type of the file
            $name = $PSItem.name
            # count of the file
            $count = $value.count
            # check if there's atleast one file
            if($count -ge 1)
            {
                # have a counting system to track the files
                $index=1
                # goo through each file names
                $value | ForEach-Object {
                    # check if they already have the template name
                    if( $PSItem -notmatch "\w_\d.$name")
                    {
                        # loop till the new file name does not exists in the value arrray
                        while( $index -notin $value)
                        {
                            # generate the new file Name
                            $newName = "wall_$index.$name"
                            Write-Output $newName
                            # if the file name generated does not exists at all
                            # then rename the file with the current name
                            if( $newName -notin $value )
                            {
                                # Move current file to the newly generated filename
                                write-output "Moving $psitem to $newName :"
                            }
                            # if the above conditional doesn't satisfy increase the index by 1
                            $index++
                        }
                    } else
                    {
                        # incase the file doesn't start/or match 
                        # the template just increase the index
                        $index++
                    }
                    write-output $index
                }
            }
        }
    }
} catch
{
    write-output $_.message
}

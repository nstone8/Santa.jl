module Santa

using Random

export santa

"""
```julia
santa(participants,[disallowed])
```
Create secret santa pairings for all entries in the iterable
`participants`. If present, `disallowed` should be an iterable
of iterables defining groups of participants who should not be
paired"

# Examples
```julia
santa(["Billy", "Susan", "Joan", "Jeremy"], #who is participating
      [["Susan", "Joan"]]) #Don't pair Susan and Joan
```
"""
function santa(participants,disallowed=[])
    #Do a sanity check that everyone in a disallowed group is
    #in participants
    for group in disallowed
        for p in group
            @assert (p in participants) "Only participants can be in disallowed groups. $p isn't a participant"
        end
    end
    #Don't allow someone to be paired with themselves
    disallowed=vcat(collect([p] for p in participants),disallowed)
    #make a little helper function
    function allowed_pair(p1,p2)
        #return false if p1 and p2 are both members of any entry
        #in disallowed
        all(
            any(.!(in.([p1,p2], tuple(group)))) for group in disallowed
        )
    end
    #reroll until all pairings are legal, then return
    while true
        #draw some pairs
        pairs=hcat(participants,shuffle(participants))
        #test if they are all legal
        if all(allowed_pair.(pairs[:,1],pairs[:,2]))
            #if they're all good, return
            return pairs
        end
        #otherwise reroll
    end
end

end # module Santa

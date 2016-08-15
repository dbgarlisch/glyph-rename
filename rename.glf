package require PWI_Glyph 2.17

set dbMap @

proc getAll { type } {
  if { ![catch {pw::Grid getAll -type pw::$type} ents] } {
    # was a grid type
  } elseif { ![catch {pw::Database getAll} dbs] } {
    # we have db ents - need to filter by type
    if { "$::dbMap" == "@" } {
      set ::dbMap [dict create]
      foreach db $dbs {
        if { ![$db getEnabled] } {
          continue
        }
        # map dbType to a list of dbs
        dict lappend ::dbMap [string range [$db getType] 4 end] $db
      }
      #puts "dbMap:"
      #dict for {type dbEnts} $::dbMap {
      #  puts [format "%10.10s: %s" $type $dbEnts]
      #}
    }
    if { [catch {dict get $::dbMap $type} ents] } {
      # key not in dbMap
      set ents {}
      #puts "$type not found in dbMap"
    }
  } else {
    set ents {}
  }
  return $ents
}


proc renameEnts { type basename } {
  set ents [getAll $type]
  if { 0 < [llength $ents] } {
    puts "Rename $type entites..."
    #foreach ent $ents {
    #  puts "  [$ent getName]: [$ent getType]"
    #}
    set colxn [pw::Collection create]
    $colxn set $ents
    $colxn do setName "X${basename}-1"
    $colxn do setName "${basename}-1"
    $colxn delete
    unset colxn
    pw::Application markUndoLevel "Rename $type entities as ${basename}-n"
  }
}

renameEnts Block     blk
renameEnts Domain    dom
renameEnts Connector con
renameEnts Model     model
renameEnts Quilt     quilt
renameEnts Surface   surface
renameEnts Curve     curve
renameEnts Shell     shell

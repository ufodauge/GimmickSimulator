local path = 'path.to.the.module.but.somehow.this.is.incorrect.path'

print( path:gsub( 'module%..+', '' ) )

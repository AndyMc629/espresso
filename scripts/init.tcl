#############################################################
#                                                             #
# init.tcl                                                    #
# ========                                                    #
#                                                             #
# Used for initializing tcl-scripts powered by the 'Espresso' #
# MPI parallel molecular dynamics program package.            #
#                                                             #
# It is a very good idea to include all custom tcl-scripts    #
# here which may enhance other programs running 'Espresso'    #
# by providing additional tcl-commands/-functions.            #
#                                                             #
###############################################################

# here do everything you want to do upon initialization.
# e. g.
puts ""
puts "*******************************************************"
puts "*                                                     *"
puts "*                    - Espresso -                     *"
puts "*                    ============                     *"
puts "*      A MPI Parallel Molecular Dynamics Program      *"
puts "*                                                     *"
puts "*                                                     *"
puts "* (c) 2002-2003                                       *"
puts "* Max-Planck-Institute for Polymer Research           *"
puts "* Mainz, Germany                                      *"
puts "*                                                     *"
puts "*******************************************************"
puts ""


# Include useful tcl-scripts providing new functions etc.

source convertDeserno.tcl
# adds 'convertDeserno2MD' & 'convertMD2Deserno' for converting particle configurations
#       stored in Deserno-file-format into Espresso format and vice versa
# adds 'convertDeserno2MDmain' & 'convertMD2DesernoMain' for directly accessing the conversion scripts
#       therefore bypassing and/or overriding the initialization procedure

source countBonds.tcl
# adds 'countBonds' returning a tcl-script with complete bonding-informations on any particle
# adds 'findPropPos' to determine the index-position of a certain property in the output of 'part'
# adds 'findBondPos' to do the same for property 'bonds'

source aux.tcl
# adds 'checkpoint_set' and 'checkpoint_read'
# adds 'prepare_vmd_connection' which aids in setting up a vmd-connection
# adds 'timeStamp' which modifies a filestring to include a prefix and the current date as postfix before the suffix
# adds 'polyBlockWrite' which writes a given 'Espresso'-configuration to disk
#      (this function in combination with 'convertMD2Deserno' replaces 'polywr.tcl')
# adds 'polyBlockWriteAll'
# adds 'polyConfMovWriteInit' & 'polyConfMovWrite' which are customized version of 'polyBlockWrite'
# adds 'analysisInit' & 'analysis' which write some analysis data
# adds 'stopParticles' which sets all particles' velocities and forces to zero

source blockfile_support.tcl
# adds 'blockfile_write_particles'
# adds 'blockfile_read_auto_particles'
# adds 'blockfile_read_particles'
# adds 'blockfile_write_bonds'
# adds 'blockfile_read_auto_bonds'
# adds 'blockfile_read_bonds'
# adds 'blockfile_write_interactions'
# adds 'blockfile_read_auto_interactions'
# adds 'blockfile_read_interactions'

source pdb.tcl
# adds 'writepsf'
# adds 'writepdb'

source polymer.tcl
# adds 'collision_tcl'
# adds 'polymer_tcl <MPC> <bond_length> <box_length> [options]'
# adds 'polymers_tcl <N_P> <MPC> <bond_length> <box_length> [options]'
# adds 'counterions_tcl <N_CI> <box_length> [options]'
# adds 'salt_tcl <N_pS> <N_nS> <box_length> [options]'
# adds 'velocities_tcl <N_T> <v_max> [options]'

source statistics.tcl
# adds 'calcObsAv <fileN> <ind>'
# adds 'findObsAv <val> <what>'
# adds 'replObsAv <fileN> <what>'
# adds 'plotObs' <destinations>'
# adds 'plotJoin <destinations> <final>'

source ABHmath.tcl
# adds 'PI' which returns an approximate value of the mathematical constant pi
# adds 'sqr <arg>' which returns the square of <arg>
# adds 'min <arg1> <arg2>' which returns the minimum of <arg1> and <arg2>
# adds 'max <arg1> <arg2>' which returns the maximum of <arg1> and <arg2>
# adds 'sign <arg>' which returns the signum-function of <arg>
# adds 'g_random' which returns random numbers which have a Gaussian distribution
# adds 'pair_dist <part_id1> <part_id2>' which returns the distance of two particles with identities <part_id1> and <part_id2>
# adds 'LinRegression <tcl-list of points {{x1 y1} {x2 y2} ...}>' which returns the least-square linear fit a*x+b and the standard errors da and db

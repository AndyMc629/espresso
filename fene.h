// This file is part of the ESPResSo distribution (http://www.espresso.mpg.de).
// It is therefore subject to the ESPResSo license agreement which you accepted upon receiving the distribution
// and by which you are legally bound while utilizing this file in any form or way.
// There is NO WARRANTY, not even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// You should have received a copy of that license along with this program;
// if not, refer to http://www.espresso.mpg.de/license.html where its current version can be found, or
// write to Max-Planck-Institute for Polymer Research, Theory Group, PO Box 3148, 55021 Mainz, Germany.
// Copyright (c) 2002-2006; all rights reserved unless otherwise stated.
#ifndef FENE_H
#define FENE_H
#include "errorhandling.h"

/** \file fene.h
 *  Routines to calculate the FENE Energy or/and FENE force 
 *  for a particle pair.
 *  \ref forces.c
 *
 *  <b>Responsible:</b>
 *  <a href="mailto:limbach@mpip-mainz.mpg.de">Hanjo</a>
*/

/************************************************************/

/// set the parameters for the fene potential
MDINLINE int fene_set_params(int bond_type, double k, double r)
{
  if(bond_type < 0)
    return TCL_ERROR;

  make_bond_type_exist(bond_type);

  bonded_ia_params[bond_type].p.fene.k = k;
  bonded_ia_params[bond_type].p.fene.r = r;

  bonded_ia_params[bond_type].type = BONDED_IA_FENE;
  bonded_ia_params[bond_type].p.fene.r2 = SQR(bonded_ia_params[bond_type].p.fene.r);
  bonded_ia_params[bond_type].num  = 1;

  /* broadcast interaction parameters */
  mpi_bcast_ia_params(bond_type, -1); 
  
  return TCL_OK;
}

/** Computes the FENE pair force and adds this
    force to the particle forces (see \ref #inter). 
    @param p1        Pointer to first particle.
    @param p2        Pointer to second/middle particle.
    @param iaparams  bond type number of the angle interaction (see \ref #inter).
    @param dx        particle distance vector
    @param force     returns force of particle 1
    @return true if the bond is broken
*/
MDINLINE int calc_fene_pair_force(Particle *p1, Particle *p2, Bonded_ia_parameters *iaparams, double dx[3], double force[3])
{
  int i;
  double fac, dist2 = sqrlen(dx);

  if(dist2 >= iaparams->p.fene.r2)
    return 1;

  fac = -iaparams->p.fene.k / (1.0 - dist2/iaparams->p.fene.r2);
  
  FENE_TRACE(if(fac > 50) fprintf(stderr,"WARNING: FENE force factor between Pair (%d,%d) large: %f at distance %f\n", p1->p.identity,p2->p.identity,fac,sqrt(dist2)) );
  
  for(i=0;i<3;i++)
    force[i] = fac*dx[i];

  ONEPART_TRACE(if(p1->p.identity==check_id) fprintf(stderr,"%d: OPT: FENE f = (%.3e,%.3e,%.3e) with part id=%d at dist %f fac %.3e\n",this_node,p1->f.f[0],p1->f.f[1],p1->f.f[2],p2->p.identity,sqrt(dist2),fac));
  ONEPART_TRACE(if(p2->p.identity==check_id) fprintf(stderr,"%d: OPT: FENE f = (%.3e,%.3e,%.3e) with part id=%d at dist %f fac %.3e\n",this_node,p2->f.f[0],p2->f.f[1],p2->f.f[2],p1->p.identity,sqrt(dist2),fac));
  
  return 0;
}

MDINLINE int fene_pair_energy(Particle *p1, Particle *p2, Bonded_ia_parameters *iaparams, double dx[3], double *_energy)
{
  double energy, dist2 = sqrlen(dx);

  if(dist2 >= iaparams->p.fene.r2) {
    char *errtext = runtime_error(128 + 2*TCL_INTEGER_SPACE);
    ERROR_SPRINTF(errtext,"{077 bond broken between particles %d and %d} ", p1->p.identity, p2->p.identity); 
    return 1;
  }

  energy = -0.5*iaparams->p.fene.k*iaparams->p.fene.r2;
  energy *= log((1.0 - dist2/iaparams->p.fene.r2));
  *_energy = energy;
  return 0;
}

#endif
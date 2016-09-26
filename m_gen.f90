!Copyright 2016,  Hiori Kino
!
!Licensed under the Apache License, Version 2.0 (the "License");
!you may not use this file except in compliance with the License.
!You may obtain a copy of the License at
!
!    http://www.apache.org/licenses/LICENSE-2.0
!
!Unless required by applicable law or agreed to in writing, software
!distributed under the License is distributed on an "AS IS" BASIS,
!WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!See the License for the specific language governing permissions and
!limitations under the License.


module m_gen
implicit none

integer,parameter,private:: mgen=284,mng=3

type t_gen_each
  integer:: JA=0,KB(2,3)=0
end type

type t_gen
  integer:: NO=0,IL=0,NG=0
  CHARACTER*5 SCHNAM
  CHARACTER*10 HMNAME
  type(t_gen_each):: r(mng)
end type

type t_genall
type(t_gen),private:: gen(mgen)
integer,private:: ig=0
integer,private:: ir=0
integer,private:: igread=0
contains
procedure:: rewind=>gen_rewind
procedure:: next=>gen_next
procedure:: getitem=>gen_getitem
procedure:: addspg=>gen_addspg
procedure:: addgen=>gen_addgen
end type

type(t_genall):: gen 

contains

subroutine gen_rewind(self)
implicit none
class(t_genall):: self
self%igread=0
end subroutine gen_rewind

logical function gen_next(self,NO,IL,NG,SCHNAM,HMNAME)
implicit none
class(t_genall):: self
integer,intent(out):: NO,IL,NG
character*5,intent(out)::SCHNAM
character*10,intent(out)::HMNAME

self%igread=self%igread+1
if (self%igread>mgen) then
gen_next=.true.
return
endif

no=self%gen(self%igread)%no
il=self%gen(self%igread)%il
ng=self%gen(self%igread)%ng
schnam=self%gen(self%igread)%schnam
hmname=self%gen(self%igread)%hmname

gen_next=.false.

end function gen_next



subroutine gen_getitem(self,k,ja,jb)
implicit none
class(t_genall):: self
integer:: k,ja,jb(2,3)

if (k> mng) then 
 write(6,*)'gen_getitem, error, k=',k
 stop
endif

ja=self%gen(self%igread)%r(k)%ja
jb=self%gen(self%igread)%r(k)%kb

end subroutine gen_getitem


!---------------------------------------------

subroutine gen_addspg(self,NO,IL,NG,SCHNAM,HMNAME)
implicit none
class(t_genall):: self
integer:: NO,IL,NG
      CHARACTER*5 SCHNAM
      CHARACTER*10 HMNAME

self%ig=self%ig+1
self%ir=0
self%gen(self%ig)%no=no
self%gen(self%ig)%il=il
self%gen(self%ig)%ng=ng
self%gen(self%ig)%schnam=schnam
self%gen(self%ig)%hmname=hmname

end subroutine gen_addspg

!---------------------------------------------

subroutine gen_addgen(self,JA,KB)
implicit none
class(t_genall):: self
integer:: JA,KB(2,3)

self%ir=self%ir+1
self%gen(self%ig)%r(self%ir)%ja=ja
self%gen(self%ig)%r(self%ir)%kb=kb 
if (self%ir>self%gen(self%ig)%ng) then 
  write(6,*)'gen_addgen: error, ir>gen(ig)%ng'
  write(6,*)'ir=',self%ir,' gen(ig)%ng=',self%gen(self%ig)%ng
endif

end subroutine gen_addgen

!---------------------------------------------

end module m_gen

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


module m_genwy
implicit none

integer,parameter,private:: mwy=284
integer,parameter,private:: mwypos=27

type t_genwy_each
integer:: npos
character:: mpos,symb(3)
end type


type t_genwy
integer:: nn=0
integer:: nuc=0
type (t_genwy_each):: wypos(mwypos)
end type t_genwy

type t_genwyall
type(t_genwy):: wy(mwy)
integer,private:: ig=0
integer,private:: iwy=0
integer,private:: igread=0

contains
procedure :: rewind=>genwy_rewind
procedure :: next=> genwy_next
procedure :: nextitem=> genwy_nextitem
procedure :: addpos=> genwy_addpos
procedure :: addid=> genwy_addid
end type

type(t_genwyall)::  genwy

contains

subroutine genwy_rewind(self)
class(t_genwyall)::self
self%igread=0
end subroutine genwy_rewind

logical function genwy_next(self,nn,nuc)
implicit none
class(t_genwyall):: self
integer:: nn,nuc

self%igread=self%igread+1
if (self%igread> mwy) then
  genwy_next=.true.
  return 
endif
nn=self%wy(self%igread)%nn
nuc=self%wy(self%igread)%nuc
genwy_next=.false.

end function genwy_next


subroutine genwy_nextitem(self,k,npos,mpos,symb)
implicit none
class(t_genwyall):: self
integer::k,npos
character:: mpos,symb(3)
npos=self%wy(self%igread)%wypos(k)%npos
mpos=self%wy(self%igread)%wypos(k)%mpos
symb=self%wy(self%igread)%wypos(k)%symb
end subroutine genwy_nextitem


subroutine genwy_addid(self,nn,nuc)
implicit none
class(t_genwyall):: self
integer:: nn,nuc

self%ig=self%ig+1
if (self%ig>mwy) then 
   write(6,*)'genwy_addid, error ig>mwy, ig=',self%ig
   stop 
endif
self%wy(self%ig)%nn=nn
self%wy(self%ig)%nuc=nuc

self%iwy=0

end subroutine genwy_addid

subroutine genwy_addpos(self,npos,mpos,symb)
implicit none
class(t_genwyall):: self
integer:: npos
character:: mpos,symb(3)

self%iwy=self%iwy+1
if (self%iwy> mwypos) then 
  write(6,*)'genwy_addpos, iwy>mwypos, iwy=',self%iwy
  stop 
endif

self%wy(self%ig)%wypos(self%iwy)%npos=npos
self%wy(self%ig)%wypos(self%iwy)%mpos=mpos
self%wy(self%ig)%wypos(self%iwy)%symb=symb

end subroutine genwy_addpos

end module m_genwy


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


program test
implicit none
call main
contains

subroutine main
implicit none
      CHARACTER*1 MPOS(30),SYMB(3,30)
      INTEGER JB(2,3,30),XYZ(3,30),NPOS(30)
integer:: nf=10
integer:: ios,k,nn,nuc,i,iall,inucmax

  open(nf,file='wycoff2015',status='unknown',action='read',iostat=ios)

  iall=0
  inucmax=0
  write(6,*)'subroutine genwy_init'
  write(6,*)'use m_genwy'
  do 
  READ(NF,100,iostat=ios) NN,NUC
  if (ios/=0) exit
  if (nn==0) exit
   iall=iall+1
  write(6,'(a,i3,a,i3,a)')'call genwy%addid(',nn,1H,,nuc,')'

  100 FORMAT(2I3)
  200       FORMAT(I2,A1,3(1X,A1))

  inucmax=max(inucmax,nuc)
  DO K=1,NUC
     READ(NF,200) NPOS(K),MPOS(K),(SYMB(I,K),I=1,3)
            IF(NPOS(K).EQ.92) NPOS(K)=192

     write(6,&
'(a,i3,1H,,a,2H,[,2(a,1H,),a,1H],a)')&
 'call genwy%addpos(',NPOS(K),"'"//MPOS(K)//"'",("'"//SYMB(I,K)//"'",I=1,3),')'
  enddo
  enddo
  write(6,*)'end subroutine genwy_init'

  close(nf) 
  write(6,*)'! total=',iall,' nucmax=',inucmax

end subroutine main

end program test


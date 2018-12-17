import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
 name: 'orderByPipe'
})
export class OrderByPipeComponent implements PipeTransform{

 transform(array: any, args: string): Array<string> {
  if(!array || array === undefined || array.length === 0 ) return array;
   if(!array.sort){
     array=[array];
     return array;
   } 
  
    array.sort((a: any, b: any) => {
      if (a.nom_fichier < b.nom_fichier) {
        return 1;
      } else if (a.timestamp_upload > b.timestamp_upload) {
        return -1;
      } else {
        return 0;
      }
    });
    return array;
  }

}
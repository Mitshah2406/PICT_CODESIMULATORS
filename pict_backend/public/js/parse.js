// // import axios from "axios";

// alert('pappaaaaaaa')
// console.log("papa");
// let btn_upload = document.getElementById('btn-upload-csv')
// console.log(btn_upload);
// btn_upload.addEventListener('click', ()=> {
//       Papa.parse(document.getElementById('upload-csv').files[0], {
//           download: true,
//           header: false,
//           complete: function(results) {
//             console.log(results)
//             // axios.post('/papa',results).then(res=>{
//             //     console.log(res.data);
//             // }).catch(e=>{

//             // })
//               let i = 0;
//               results.data.map((data, index)=> {
//                   if(i===0){
//                       let table = document.getElementById('tbl-data');
//                       generateTableHead(table,data);
//                   } else{
//                       let table = document.getElementById('tbl-data');
//                       generateTableRows(table,data);
//                   }
//                   i++
      
//               })
//               /*
              
//               results.data.map((data, index)=> {
//                   if (i === 0) {
//                       let table = document.getElementById('tbl-data');
//                       generateTableHead(table, data);
//                   } else {
//                       let table = document.getElementById('tbl-data');
//                       generateTableRows(table, data);
//                   }
//                   i++;
//               });
//               */
//           }
//       });
//       console.log("hi")
//       function disp(){
//       let submitBtn = document.getElementById('onboardingSubmit')
//       console.log(submitBtn);
//           submitBtn.classList.remove('submitBtn')
//           submitBtn.classList.add('show')
//       }
//       disp()
//       });
      
//       function generateTableHead(table, data) {
//       let thead = table.createTHead();
//       let row = thead.insertRow();
//       for(let key of data) {
//           let th = document.createElement('th');
//           let text = document.createTextNode(key);
//           th.appendChild(text);
//           row.appendChild(th);
//       }
//       }
      
//       function generateTableRows(table, data) {
//       let newRow = table.insertRow(-1);
//       data.map((row, index)=> {
//           let newCell = newRow.insertCell();
//           let newText = document.createTextNode(row);
//           newCell.appendChild(newText);
//       });
//       }
//       generateTableRows()
      
      


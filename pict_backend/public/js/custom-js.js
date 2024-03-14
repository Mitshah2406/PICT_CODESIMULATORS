// import axios from "axios";

const passInput = document.querySelector(".input-grooup input");
const toggleIcon = document.querySelector(".input-grooup .tooggle");
const ripple = document.querySelector(".input-grooup .ripple");
const percentBar = document.querySelector(".strength-percent span");
const passLable = document.querySelector(".strength-label");
passInput.addEventListener("input", handlePassInput);

// alert('password working')
function handlePassInput(e) {
    if (passInput.value.length === 0) {
        passLable.innerHTML = "Strength";
        addClass();
    }
    else if (passInput.value.length <= 4) {
        passLable.innerHTML = "Weak";
        addClass("weak");
    }
    else if (passInput.value.length <= 7) {
        passLable.innerHTML = "Not Bad";
        addClass("average");
    }
    else {
        passLable.innerHTML = "Strong";
        addClass("strong");
    }
}
function addClass(className) {
    percentBar.classList.remove("weak");
    percentBar.classList.remove("average");
    percentBar.classList.remove("strong");
    if (className) {
        percentBar.classList.add(className);
    }
}
toggleIcon.addEventListener('click', (e) => {
    if (passInput.type === "password") {
        passInput.type = "text";
        toggleIcon.innerHTML = `
<svg width="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">                                    <path d="M9.76045 14.3667C9.18545 13.7927 8.83545 13.0127 8.83545 12.1377C8.83545 10.3847 10.2474 8.97168 11.9994 8.97168C12.8664 8.97168 13.6644 9.32268 14.2294 9.89668" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>                                    <path d="M15.1049 12.6987C14.8729 13.9887 13.8569 15.0067 12.5679 15.2407" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>                                    <path d="M6.65451 17.4722C5.06751 16.2262 3.72351 14.4062 2.74951 12.1372C3.73351 9.85823 5.08651 8.02823 6.68351 6.77223C8.27051 5.51623 10.1015 4.83423 11.9995 4.83423C13.9085 4.83423 15.7385 5.52623 17.3355 6.79123" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>                                    <path d="M19.4473 8.99072C20.1353 9.90472 20.7403 10.9597 21.2493 12.1367C19.2823 16.6937 15.8063 19.4387 11.9993 19.4387C11.1363 19.4387 10.2853 19.2987 9.46729 19.0257" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>                                    <path d="M19.8868 4.24951L4.11279 20.0235" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>                                </svg>  
`
    } else {
        passInput.type = "password";
        toggleIcon.innerHTML = ` <svg width="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M22.4541 11.3918C22.7819 11.7385 22.7819 12.2615 22.4541 12.6082C21.0124 14.1335 16.8768 18 12 18C7.12317 18 2.98759 14.1335 1.54586 12.6082C1.21811 12.2615 1.21811 11.7385 1.54586 11.3918C2.98759 9.86647 7.12317 6 12 6C16.8768 6 21.0124 9.86647 22.4541 11.3918Z"
                    stroke="#130F26"></path>
                <circle cx="12" cy="12" r="5" stroke="#130F26"></circle>
                <circle cx="12" cy="12" r="3" fill="#130F26"></circle>
                <mask mask-type="alpha" maskUnits="userSpaceOnUse" x="9" y="9" width="6" height="6">
                    <circle cx="12" cy="12" r="3" fill="#130F26"></circle>
                </mask>
                <circle opacity="0.89" cx="13.5" cy="10.5" r="1.5" fill="white"></circle>
            </svg>`
    }
})



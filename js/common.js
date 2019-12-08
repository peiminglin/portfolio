function toggle(target, addOn){
    const container = document.querySelector(target);
    if (container.classList.contains(addOn)){
        container.classList.remove(addOn);
    }else{
        container.classList.add(addOn);
    }
}

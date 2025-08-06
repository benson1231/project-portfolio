import { useState } from "react";
import { IoFish } from "react-icons/io5";
import styles from "./Fish.module.css";

function Fish() {
  const [speak, setSpeak] = useState(false);

  const handleClick = () => {
    setSpeak(true);
  };

  return (
    <>
      <IoFish className={styles["fish-icon"]} onClick={handleClick} />
      {speak && <div className={styles.speech}>我是一隻鯖魚～肥瘦相間</div>}
    </>
  );
}

export default Fish;

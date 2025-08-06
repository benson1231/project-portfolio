import { CgAirplane } from "react-icons/cg";
import styles from './Airplane.module.css';

function Airplane() {
    
    return (
        <>
        <div>
            <CgAirplane className={styles['airplane-icon']} />
        </div>
        </>
    );
}

export default Airplane;
import { apiClient } from '@/lib/axios'

function LandingPage() {
  return (
    <button onClick={()=>{
      apiClient.get('/health');
    }}>
      Click
    </button>
  );
}

export default LandingPage;